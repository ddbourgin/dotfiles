import json
import os
import shutil
import stat
import subprocess
import tempfile
import tomllib
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CHEZMOI = os.environ.get("CHEZMOI", "chezmoi")


class ChezmoiMigrationTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        self.env = os.environ.copy()
        self.env.update(
            HOME=str(self.home),
            XDG_CONFIG_HOME=str(self.home / ".config"),
            XDG_DATA_HOME=str(self.home / ".local/share"),
            XDG_CACHE_HOME=str(self.home / ".cache"),
        )
        self.config = self.home / "chezmoi.toml"
        self.config.write_text("")
        self.source = ROOT

    def chezmoi(self, *args):
        return subprocess.run(
            [
                CHEZMOI,
                "--source", str(self.source),
                "--destination", str(self.home),
                "--config", str(self.config),
                *args,
            ],
            env=self.env,
            text=True,
            capture_output=True,
            check=True,
        )

    def test_apply_preserves_existing_directory_contents_and_ssh(self):
        nvim = self.home / ".config/nvim"
        nvim.mkdir(parents=True)
        (nvim / "local-only").write_text("keep")
        ssh = self.home / ".ssh"
        ssh.mkdir()
        (ssh / "config").write_text("local ssh config")
        self.chezmoi("apply")
        self.assertEqual((nvim / "local-only").read_text(), "keep")
        self.assertEqual((ssh / "config").read_text(), "local ssh config")
        for target in (
            ".bash_profile", ".bashrc", ".aliases", ".vimrc", ".zshrc",
            ".config/nvim/init.lua", ".config/nvim/.gitignore",
            ".config/nvim/.neoconf.json", ".config/opencode/cli.json",
            ".config/opencode/opencode.jsonc",
            ".config/karabiner/karabiner.json",
        ):
            with self.subTest(target=target):
                self.assertTrue((self.home / target).is_file())
        self.assertFalse((self.home / ".dotfiles").exists())
        self.assertEqual(self.chezmoi("status").stdout, "")

    def test_bash_reads_regular_aliases_file(self):
        self.chezmoi("apply")
        (self.home / ".aliases").write_text("export ALIASES_LOADED=yes\n")
        result = subprocess.run(
            ["bash", "--noprofile", "--norc", "-c",
             '. "$HOME/.bashrc"; printf "%s" "$ALIASES_LOADED"'],
            env=self.env,
            text=True,
            capture_output=True,
            check=True,
        )
        self.assertEqual(result.stdout, "yes")

    def test_local_runtime_files_in_source_are_not_managed(self):
        self.source = self.home / "source"
        self.source.mkdir()
        shutil.copy(ROOT / ".chezmoiroot", self.source)
        shutil.copytree(ROOT / "home", self.source / "home")
        opencode = self.source / "home/dot_config/opencode"
        (opencode / "service.json").write_text("private local data")
        (opencode / "node_modules").mkdir()
        (opencode / "node_modules/local").write_text("local dependency")
        for relative in (
            "-sh", "opencode.jsonc.bak", "tui.jsonc",
            "herdr-opencode/tui.js", "herdr-tui-session.js",
            "plugins/herdr-agent-state.js", "plugins/rtk.ts",
        ):
            path = opencode / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text("local installer data")
        nvim = self.source / "home/dot_config/nvim"
        (nvim / "debug").write_text("local debug data")

        self.chezmoi("apply")

        self.assertFalse((self.home / ".config/opencode/service.json").exists())
        self.assertFalse((self.home / ".config/opencode/node_modules").exists())
        self.assertFalse((self.home / ".config/nvim/debug").exists())
        for relative in (
            "-sh", "opencode.jsonc.bak", "tui.jsonc",
            "herdr-opencode/tui.js", "herdr-tui-session.js",
            "plugins/herdr-agent-state.js", "plugins/rtk.ts",
        ):
            with self.subTest(relative=relative):
                self.assertFalse((self.home / ".config/opencode" / relative).exists())

    def test_git_ignores_local_opencode_artifacts(self):
        paths = [
            "opencode/-sh", "opencode/opencode.jsonc.bak",
            "opencode/service.json", "opencode/node_modules/local",
            "home/dot_config/opencode/-sh",
            "home/dot_config/opencode/opencode.jsonc.bak",
            "home/dot_config/opencode/service.json",
            "home/dot_config/opencode/node_modules/local",
        ]
        result = subprocess.run(
            ["git", "check-ignore", "--no-index", *paths],
            cwd=ROOT,
            text=True,
            capture_output=True,
            check=True,
        )
        self.assertEqual(set(result.stdout.splitlines()), set(paths))

    def test_portable_agent_and_herdr_preferences_are_managed(self):
        skills = self.home / ".agents/skills"
        skills.mkdir(parents=True)
        (skills / "local-only").write_text("private installed instructions")
        self.chezmoi("apply")
        herdr = tomllib.loads((self.home / ".config/herdr/config.toml").read_text())
        self.assertFalse(herdr["onboarding"])
        self.assertEqual(herdr["theme"]["name"], "tokyo-night")
        self.assertEqual(herdr["theme"]["dark_name"], "tokyo-night")
        self.assertEqual(herdr["theme"]["light_name"], "tokyo-night-day")
        self.assertTrue(herdr["theme"]["auto_switch"])
        self.assertEqual(herdr["terminal"]["new_cwd"], "follow")
        agents = (self.home / "AGENTS.md").read_text()
        self.assertEqual(agents, (ROOT / "home/AGENTS.md").read_text())
        for internal in ("adobe", "workiq", "pluto", "slack", "glean"):
            with self.subTest(internal=internal):
                self.assertNotIn(internal, agents.lower())
        self.assertFalse((self.home / ".agents").is_symlink())
        self.assertEqual(
            (skills / "local-only").read_text(), "private installed instructions"
        )

    def opencode_config(self):
        path = self.home / ".config/opencode/opencode.jsonc"
        return json.loads(
            path.read_text()
            .replace("// restrict just to ghcp for work", "")
            .replace(",\n}", "\n}")
        )

    def test_public_opencode_defaults_have_no_workiq_configuration(self):
        self.chezmoi("apply")
        config = self.opencode_config()
        self.assertEqual(config["enabled_providers"], ["github-copilot"])
        self.assertEqual(
            config.get("plugins"),
            ["superpowers@git+https://github.com/obra/superpowers.git#v7.0.2"],
        )
        self.assertNotIn("mcp", config)
        cli = json.loads((self.home / ".config/opencode/cli.json").read_text())
        self.assertNotIn("plugins", cli)

    def test_workiq_is_rendered_only_from_local_data(self):
        fake_url = "https://workiq.example.invalid/mcp"
        fake_client = 'fake-client-"quoted"'
        fake_metadata = "https://login.example.invalid/test/.well-known/openid-configuration"
        self.config.write_text(
            "[data.workiq]\n"
            f"url = {json.dumps(fake_url)}\n"
            f"clientId = {json.dumps(fake_client)}\n"
            "callbackPort = 12798\n"
            f"authServerMetadataUrl = {json.dumps(fake_metadata)}\n"
        )
        self.chezmoi("apply")
        self.assertEqual(
            self.opencode_config()["mcp"]["servers"],
            {
                "workiq": {
                    "type": "remote",
                    "url": fake_url,
                    "oauth": {
                        "client_id": fake_client,
                        "callback_port": 12798,
                        "auth_server_metadata_url": fake_metadata,
                    },
                },
            },
        )
        path = self.home / ".config/opencode/opencode.jsonc"
        self.assertEqual(stat.S_IMODE(path.stat().st_mode), 0o600)
        for source in (ROOT / "home/dot_config/opencode").iterdir():
            if source.is_file():
                for value in (fake_url, fake_client, fake_metadata):
                    self.assertNotIn(value, source.read_text())

    def test_incomplete_workiq_data_fails_before_apply(self):
        self.config.write_text(
            '[data.workiq]\nurl = "https://workiq.example.invalid/mcp"\n'
        )
        with self.assertRaises(subprocess.CalledProcessError) as failure:
            self.chezmoi("cat", str(self.home / ".config/opencode/opencode.jsonc"))
        self.assertIn("clientId", failure.exception.stderr)

    def test_apply_replaces_dotbot_links_without_changing_old_checkout(self):
        old = self.home / "old-checkout"
        old.mkdir()
        (old / "aliases").write_text("local edits\n")
        (old / "nvim").mkdir()
        (old / "nvim/local-only").write_text("keep local edits")
        (self.home / ".aliases").symlink_to(old / "aliases")
        (self.home / ".config").mkdir()
        (self.home / ".config/nvim").symlink_to(old / "nvim")

        self.chezmoi("apply")

        self.assertEqual((old / "aliases").read_text(), "local edits\n")
        self.assertEqual((old / "nvim/local-only").read_text(), "keep local edits")
        self.assertFalse((self.home / ".config/nvim").is_symlink())
        self.assertTrue((self.home / ".config/nvim/init.lua").is_file())

    def test_conda_path_is_set_by_local_data(self):
        conda = self.home / "example 'conda' $dir/bin/conda"
        conda.parent.mkdir(parents=True)
        conda.write_text("#!/bin/sh\nprintf 'export CONDA_LOADED=yes\\n'\n")
        conda.chmod(0o755)
        self.config.write_text(
            '[data]\ncondaRoot = "' + str(conda.parent.parent) + '"\n'
        )
        self.chezmoi("apply")
        result = subprocess.run(
            ["bash", "--noprofile", "--norc", "-c",
             '. "$HOME/.bash_profile"; printf "%s" "$CONDA_LOADED"'],
            env=self.env,
            text=True,
            capture_output=True,
            check=True,
        )
        self.assertEqual(result.stdout, "yes")


if __name__ == "__main__":
    unittest.main()
