# Dotfiles

This repository contains configurations for my personal development environment, managed by **Yadm**.
It targets **macOS** (primary) and **Linux** systems, aiming for a portable and reproducible setup.

## Installation

On a new machine, simply run:

```bash
# Clone all the config files
yadm clone https://github.com/ukeSJTU/dotfiles.git --no-bootstrap
yadm status
```

If you want to bootstrap the system (install dependencies, setup tools, etc.), run:

```bash
yadm bootstrap
```

## Core Tools

### Yadm

**Description**: Yet Another Dotfiles Manager. It wraps Git to manage files in `$HOME`.
**Configuration**: The repository itself (`.git/` inside `$HOME`).
**Bootstrap**: `~/.config/yadm/bootstrap` (Handles initial setup & installation).

**Common Commands**:

* `yadm status`: Check status of dotfiles.
* `yadm add <file>`: Track a new config file.
* `yadm commit -m "..."`: Save changes.
* `yadm push`: Upload to remote.

### Mise (mise-en-place)

**Description**: The core version manager for languages (Node, Python, Go, Rust) and modern CLI tools (ripgrep, lazygit, etc.).
**Configuration**: `~/.config/mise/config.toml`

**Maintenance**:
我主要用 mise 来管理编程语言和开发工具。

* **Check Updates**: `mise outdated` (查看有哪些工具有新版本)
* **Upgrade Tools**: `mise upgrade` (更新所有工具到配置文件允许的最新版)
* **Cleanup**: `mise prune -y` (清理不再需要的旧版本，释放空间)

**System Update**:
按照 bootstrap 脚本，我们使用的是 curl 安装的 standalone 版本：

* **Update Mise**: `mise self-update`

*(Note: If installed via Homebrew, use `brew upgrade mise`)*

### Homebrew

**Description**: The package manager for macOS system-level dependencies, GUI apps (Casks), and heavy tools not suitable for Mise.
**Configuration**: `~/.Brewfile` (List of installed packages).

**Common Commands**:

* **Install Dependencies**: `brew bundle --global` (Install everything in Brewfile).
* **Snapshot Current Setup**: `brew bundle dump --global --force --describe` (Update Brewfile with currently installed packages).
* **Cleanup**: `brew cleanup`.

---

## All Other Tools

### Zsh

**Description**: The default shell. Configured for modularity and speed.
**Configuration**:

* `~/.zshenv`: Environment variables & path setup (Bootstrap).
* `~/.zshrc`: Interactive shell config, plugin loading.
* `~/.config/zsh/aliases.zsh`: Custom aliases.
* `~/.config/zsh/custom.zsh`: Functions and keybindings.

**Features**:

* **Plugins**: Managed by `zplug`.
* **Structure**: Uses `ZDOTDIR` to keep `$HOME` clean.

### Starship

**Description**: Cross-shell prompt. Fast, customizable, and informative.
**Configuration**: `~/.config/starship.toml`

### Neovim

**Description**: Hyperextensible Vim-based text editor. Configured using Lua (likely based on LazyVim architecture).
**Configuration**: `~/.config/nvim/`

* `init.lua`: Entry point.
* `lazy-lock.json`: **Crucial**. Locks plugin versions to ensure consistency across machines.

**Common Commands**:

* `:Lazy`: Open plugin manager interface.
* `:checkhealth`: Verify environment status (Node/Python providers via Mise).

### Git

**Description**: Version control system configuration.
**Configuration**:

* `~/.gitconfig`: User info, aliases, delta (diff viewer) integration.
* `~/.gitignore_global`: Global ignore rules (DS_Store, etc.).

**Features**:

* **Delta**: Syntax highlighting for git diffs.
* **Credential Helper**: Uses `osxkeychain` on macOS.

### Lazygit

**Description**: Simple terminal UI for git commands.
**Configuration**: `~/.config/lazygit/config.yml`

**Common Commands**:

* `lg`: Alias to open lazygit.
