import os
from pathlib import Path
import subprocess
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "scripts/install_opencode_extras.sh"


class InstallExtrasTest(unittest.TestCase):
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
            env = dict(os.environ, HOME=str(home), XDG_CONFIG_HOME=str(home / ".config"))
            result = subprocess.run(
                ["bash", str(SCRIPT), "--dry-run"],
                env=env, text=True, capture_output=True, check=True,
            )
            self.assertIn("example-org/example-skills", result.stdout)
            self.assertIn("--skill example", result.stdout)
            self.assertFalse((home / "hook-ran").exists())
            self.assertFalse((home / ".cache").exists())

    def test_unknown_option_is_rejected(self):
        result = subprocess.run(
            ["bash", str(SCRIPT), "--invalid"],
            text=True, capture_output=True,
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Usage:", result.stderr)


if __name__ == "__main__":
    unittest.main()
