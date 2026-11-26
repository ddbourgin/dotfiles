# Dotfiles

This repository uses [chezmoi](https://www.chezmoi.io/) to manage shell,
Neovim, OpenCode, Karabiner, and Herdr configuration. The source files are in `home/`;
`.chezmoiroot` tells chezmoi to use that directory. Files such as `gitconfig`,
`tmux.conf`, `ssh/config`, and the older Vim configuration remain in the
repository but are not installed automatically.

## Set up a new machine

Install Git and chezmoi using the [chezmoi installation
guide](https://www.chezmoi.io/install/). Then clone this repository. For example:

```sh
git clone https://github.com/ddbourgin/dotfiles.git "$HOME/.dotfiles"
chezmoi --source "$HOME/.dotfiles" diff
```

Review the diff and back up any existing target files before applying it:

```sh
chezmoi --source "$HOME/.dotfiles" apply
```

The source directory can be elsewhere. Use its path in place of
`$HOME/.dotfiles` in these commands. Chezmoi does not create or replace
`~/.dotfiles`.

The Bash profile looks for Conda at `$HOME/anaconda3` by default. To use a
different location, add this to your **local**, untracked chezmoi configuration
file, normally `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
condaRoot = "/absolute/path/to/anaconda3"
```

Do not put credentials, SSH keys, or host-specific SSH settings in this
repository. Chezmoi does not manage `~/.ssh` here. Configure SSH separately,
and keep private keys in `~/.ssh` with appropriate permissions.

## Portable agent and tool preferences

Only reviewed, portable files belong in the managed source. Do not copy or
symlink all of `~/.agents` or `~/.config/opencode` into this repository.

| Source | Target | Contents |
| --- | --- | --- |
| `home/AGENTS.md` | `~/AGENTS.md` | General writing, HTML, brainstorming, and coding preferences |
| `home/dot_config/herdr/config.toml` | `~/.config/herdr/config.toml` | Herdr preferences, including the corrected `tokyo-night` theme |
| `home/dot_config/opencode/private_opencode.jsonc.tmpl` | `~/.config/opencode/opencode.jsonc` | Portable defaults and optional local server configuration |

Each agent has its own instruction discovery rules. The managed `~/AGENTS.md`
is not copied to every agent's global configuration directory.

OpenCode retains the GitHub Copilot provider restriction. Its Superpowers
plugin is pinned to `v7.0.2` using the
[documented Git ref syntax](https://github.com/obra/superpowers/blob/v7.0.2/.opencode/INSTALL.md).
This uses OpenCode V2 configuration (`plugins` and `mcp.servers`). Superpowers
requires OpenCode V2 version 2.0.4 or later. OpenCode installs the plugin when
it loads the configuration; chezmoi does not download or install it.

The following stay local and are not copied into this repository:

- OpenCode's `-sh` file, `opencode.jsonc.bak`, `service.json`, and `node_modules`.
- Installer-owned Herdr files: `tui.jsonc`, `herdr-opencode/tui.js`,
  `herdr-tui-session.js`, `plugins/herdr-agent-state.js`, and the Herdr plugin
  pointer in `cli.json`.
- RTK's installer-owned `plugins/rtk.ts`.
- Installed agent skills, Clarity, skill lockfiles, and internal work
  instructions or AI Platform/Pluto skills.
- The Autoresearch package, skill, commands, and documentation, pending a
  separate ownership and provenance review.

Git and chezmoi ignore OpenCode's `-sh`, `opencode.jsonc.bak`, `service.json`,
and `node_modules`. Chezmoi also excludes the listed Herdr and RTK generated
files. Keep any other local or installer-owned files outside the managed source.
Applying the managed `cli.json` can reset installer-added plugin pointers;
restore those through the owning installer after migration, not by adding them
to the public source.

### Local WorkIQ configuration

The public OpenCode defaults contain no WorkIQ server or organization-specific
OAuth values. If needed, add the following table to your local
`~/.config/chezmoi/chezmoi.toml`, using values from your own approved setup.
These example values are fake:

```toml
[data.workiq]
url = "https://workiq.example.invalid/mcp"
clientId = "fake-client-id"
callbackPort = 12798
authServerMetadataUrl = "https://login.example.invalid/test/.well-known/openid-configuration"
```

All four fields are required when the table is present. Omit the table to omit
the server. Before migrating an existing local server configuration, save its
values in this local table. Otherwise, applying the public defaults replaces
that server configuration.

Keep the local chezmoi configuration private and outside this repository.
The `private_` source prefix gives the rendered OpenCode file mode `600`; it
does not encrypt the file. A chezmoi diff can display local values, so do not
publish that output. Do not copy the rendered file back into the public source
or replace the template with it.

## Migrate from Dotbot

Do not pull these changes into a checkout that existing Dotbot links point to
until you have backed up that checkout and any uncommitted changes. This
migration moves the managed source files to new paths. Instead, use a separate
clone or worktree that contains the migration, and pass its path with `--source`.

Before applying, back up your existing target files and directories. Check for
local or ignored files in the old linked Neovim and OpenCode directories, such
as OpenCode credentials or dependencies. Applying chezmoi replaces those
directory links with directories of managed files. It does not delete the old
checkout, but files that exist only there will no longer appear at the old
target paths. Copy any you need into the new target directories after review.
Chezmoi does not remove other files already in regular target directories.

Run `chezmoi --source /path/to/migration diff` first and inspect the output.
Only then run `chezmoi --source /path/to/migration apply`. Compare your backup
with the resulting files and restore any machine-specific changes you need.
Keep the old checkout until you have verified the result.

## Updating and testing

Edit managed files in `home/`, review with `chezmoi --source /path/to/repo diff`,
and run `chezmoi --source /path/to/repo apply`. Unlike the old directory
symlinks, these target files are copies: changes to a target are not
automatically saved to this repository.

The former Dotbot installer also ran `scripts/install_cli_tools.sh`. That script
is still available, but it installs packages and shell tools. Review and run it
separately only if you want those changes.

With Python 3.11 or later and chezmoi installed, run the isolated migration checks with:

```sh
python3 -m unittest discover -s tests -v
```

The checks use temporary home directories. Set `CHEZMOI` to an executable path
if chezmoi is not on `PATH`.
