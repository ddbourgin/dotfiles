# dotfiles

## Set up

You'll want to install the following items first:

### OSX

```sh
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
echo "Host *\n  AddKeysToAgent yes\n  IdentityFile ~/.ssh/id_ed25519" >> ~/.ssh/config # run this only if ~/.ssh/config doesn't already exist
ssh-add -K ~/.ssh/id_ed25519 
```

Then [add the ssh key to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

You may also want to install the [Solarized Dark Higher Contrast iTerm color scheme](https://iterm2colorschemes.com/).

### Ubuntu

```sh
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519 
```

Then [add the ssh key to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

## Installation

Clone the repo into the home directory using

```sh
git clone https://github.com/ddbourgin/dotfiles.git ~/.dotfiles && cd ~/.dotfiles
```

and then

```sh
./install
```

The installer uses Dotbot to link the configuration and run the tool
installers. The OpenCode extras can also be previewed or installed separately:

```sh
bash scripts/install_opencode_extras.sh --dry-run
bash scripts/install_opencode_extras.sh
```

The extras script installs the public Clarity skill and Autoresearch from its
upstream default branch globally. It also sets up RTK and Herdr integrations
when those tools are available. Its component list appears at the top of the
script, and it prints a
header for each component. OpenCode loads the pinned Superpowers plugin from
its configuration. The script skips missing tools and does not run local hooks
in dry-run mode.

### Local OpenCode settings

OpenCode V2 loads both `~/.config/opencode/opencode.json` and
`~/.config/opencode/opencode.jsonc`. The JSON file is ignored by Git and can
hold machine-specific settings, such as private server configuration or
additional instruction files. Missing instruction files are skipped. For example:

```json
{
  "instructions": ["~/.config/opencode/.local/instructions.md"],
  "mcp": {
    "servers": {
      "example": {
        "type": "remote",
        "url": "https://example.com/mcp"
      }
    }
  }
}
```

Keep that file private if it contains sensitive settings. OpenCode may use a
background service, so restart the service if it does not pick up a change.

The extras script reads optional local inputs from
`~/.config/opencode/.local/`. Set `DOTFILES_OPENCODE_LOCAL_DIR` to use another
directory. Add one skill source per line to `skills.local`. Empty lines and
lines starting with `#` are ignored. An optional `--skill` selects one skill;
names and sources must not contain spaces.

```text
# Example only
example-org/example-skills
example-org/other-skills --skill example
```

If `opencode-extras.local.sh` exists in that directory, the script runs it with
Bash after the public installers. It is local executable code; only add commands
you trust. Neither local input is tracked.

Installed skills, generated OpenCode commands and plugins, local configuration,
credentials, and runtime dependencies are intentionally not tracked. Hand-written
agents and commands outside the listed generated paths can still be tracked.
