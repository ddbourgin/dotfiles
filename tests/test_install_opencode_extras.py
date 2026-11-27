import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "scripts/install_opencode_extras.sh"


class InstallExtrasTest(unittest.TestCase):
    def test_existing_tag_checkout_moves_to_default_branch(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            remote = home / "remote"
            remote.mkdir()
            git = shutil.which("git")
            self.assertIsNotNone(git)

            def git_run(*args):
                return subprocess.run(
                    [git, *args], text=True, capture_output=True, check=True,
                )

            git_run("init", "-b", "main", str(remote))
            git_run("-C", str(remote), "config", "user.name", "Test")
            git_run("-C", str(remote), "config", "user.email", "test@example.com")
            scripts = remote / "scripts"
            scripts.mkdir()
            (scripts / "install.sh").write_text('printf installed > "$HOME/installed"\n')
            git_run("-C", str(remote), "add", "scripts/install.sh")
            git_run("-C", str(remote), "commit", "-m", "initial")
            git_run("-C", str(remote), "tag", "v2.3.0")
            (remote / "new-version").write_text("new\n")
            git_run("-C", str(remote), "add", "new-version")
            git_run("-C", str(remote), "commit", "-m", "new version")

            cache = home / ".cache/dotfiles/autoresearch"
            cache.parent.mkdir(parents=True)
            git_run("clone", "--branch", "v2.3.0", "--single-branch", str(remote), str(cache))
            binary = home / "bin"
            binary.mkdir()
            wrapper = binary / "git"
            wrapper.write_text(
                "#!/bin/bash\n"
                'if [[ "$3" == remote && "$4" == get-url && "$5" == origin ]]; then\n'
                '  echo https://github.com/uditgoenka/autoresearch.git\n'
                "else\n"
                f'  exec "{git}" "$@"\n'
                "fi\n"
            )
            wrapper.chmod(0o755)
            env = dict(
                os.environ, HOME=str(home), PATH=f"{binary}:/usr/bin:/bin",
                XDG_CACHE_HOME=str(home / ".cache"),
                DOTFILES_OPENCODE_LOCAL_DIR=str(home / "local"),
            )
            result = subprocess.run(
                ["/bin/bash", str(SCRIPT)], env=env, text=True,
                capture_output=True,
            )
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertEqual(git_run("-C", str(cache), "branch", "--show-current").stdout.strip(), "main")
            self.assertEqual(
                git_run("-C", str(cache), "rev-parse", "HEAD").stdout,
                git_run("-C", str(remote), "rev-parse", "HEAD").stdout,
            )
            self.assertEqual((home / "installed").read_text(), "installed")
            (remote / "new-version").write_text("newer\n")
            git_run("-C", str(remote), "add", "new-version")
            git_run("-C", str(remote), "commit", "-m", "update")
            result = subprocess.run(
                ["/bin/bash", str(SCRIPT)], env=env, text=True, capture_output=True,
            )
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertEqual(
                git_run("-C", str(cache), "rev-parse", "HEAD").stdout,
                git_run("-C", str(remote), "rev-parse", "HEAD").stdout,
            )
            (cache / "new-version").write_text("local edits\n")
            result = subprocess.run(
                ["/bin/bash", str(SCRIPT)], env=env, text=True, capture_output=True,
            )
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("cache has local changes", result.stderr)
            self.assertEqual((cache / "new-version").read_text(), "local edits\n")

    def test_dry_run_does_not_run_hook_or_create_cache(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            local = home / ".config/opencode/.local"
            local.mkdir(parents=True)
            (local / "skills.local").write_text(
                "# example\nexample-org/example-skills --skill example\n"
            )
            (local / "opencode-extras.local.sh").write_text(
                f"touch '{home}/hook-ran'\n"
            )
            env = dict(
                os.environ,
                HOME=str(home),
                XDG_CONFIG_HOME=str(home / ".config"),
                XDG_CACHE_HOME=str(home / ".cache"),
                DOTFILES_OPENCODE_LOCAL_DIR=str(local),
            )
            result = subprocess.run(
                ["bash", str(SCRIPT), "--dry-run"],
                env=env, text=True, capture_output=True, check=True,
            )
            headers = [
                line for line in result.stdout.splitlines()
                if line.startswith("==> Installing ")
            ]
            self.assertEqual(headers, [
                "==> Installing Clarity (skill)",
                "==> Installing Autoresearch (skill and commands)",
                "==> Installing RTK (OpenCode plugin)",
                "==> Installing Herdr (OpenCode integration)",
                "==> Installing local skill: example-org/example-skills",
            ])
            self.assertIn("example-org/example-skills", result.stdout)
            self.assertIn("--skill example", result.stdout)
            self.assertIn(
                "git clone https://github.com/uditgoenka/autoresearch.git",
                result.stdout,
            )
            self.assertIn("fetch origin +refs/heads/*:refs/remotes/origin/*", result.stdout)
            self.assertIn("merge --ff-only", result.stdout)
            self.assertNotIn("v2.3.0", result.stdout)
            self.assertFalse((home / "hook-ran").exists())
            self.assertFalse((home / ".cache").exists())

    def test_missing_tools_are_skipped_without_running_installers(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            env = dict(
                os.environ,
                HOME=str(home),
                XDG_CONFIG_HOME=str(home / ".config"),
                XDG_CACHE_HOME=str(home / ".cache"),
                DOTFILES_OPENCODE_LOCAL_DIR=str(home / "local"),
                PATH="",
            )
            result = subprocess.run(
                ["/bin/bash", str(SCRIPT)],
                env=env, text=True, capture_output=True, check=True,
            )
            for name in ("npx", "git", "rtk", "herdr"):
                self.assertIn(f"{name} is not installed", result.stderr)
            self.assertFalse((home / ".cache").exists())

    def test_invalid_local_entry_fails_in_dry_run(self):
        with tempfile.TemporaryDirectory() as directory:
            home = Path(directory)
            local = home / "local"
            local.mkdir()
            (local / "skills.local").write_text("example-org/example-skills --invalid\n")
            env = dict(
                os.environ, HOME=str(home),
                XDG_CACHE_HOME=str(home / ".cache"),
                DOTFILES_OPENCODE_LOCAL_DIR=str(local),
            )
            result = subprocess.run(
                ["bash", str(SCRIPT), "--dry-run"],
                env=env, text=True, capture_output=True,
            )
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("Invalid skills.local entry", result.stderr)

    def test_unknown_option_is_rejected(self):
        result = subprocess.run(
            ["bash", str(SCRIPT), "--invalid"],
            text=True, capture_output=True,
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Usage:", result.stderr)


if __name__ == "__main__":
    unittest.main()
