# Dotfiles

This repository contains configurations for my personal development environment, managed by **Yadm**.
It targets **macOS** (primary), **Linux**, and **Windows** systems, aiming for a portable and reproducible setup.

## Platform Support

- **macOS**: Full support with Homebrew for package management
- **Linux**: Full support with distribution-specific package managers
- **Windows**: Support via Git Bash/WSL with Scoop for package management

## Installation

### Prerequisites

**macOS/Linux:**
```bash
# Install yadm
# macOS:
brew install yadm

# Linux (Debian/Ubuntu):
sudo apt install yadm

# Linux (Arch):
sudo pacman -S yadm

# Or use the standalone installer:
curl -fLo ~/bin/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm && chmod a+x ~/bin/yadm
```

**Windows:**
```powershell
# Install Git for Windows (includes Git Bash)
winget install Git.Git

# Install Scoop (package manager)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

# Install yadm
scoop install yadm
```

### Clone Repository

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

The bootstrap script will:
- Detect your operating system automatically
- Install Starship (cross-shell prompt)
- Install mise (version manager for languages and tools)
- Install platform-specific packages (Homebrew on macOS, Scoop on Windows)
- Set up all development tools from `~/.config/mise/config.toml`

## Core Tools

### Yadm

**Description**: Yet Another Dotfiles Manager. It wraps Git to manage files in `$HOME`.
**Configuration**: The repository itself (`.git/` inside `$HOME`).
**Bootstrap**: `~/.config/yadm/bootstrap` (Handles initial setup & installation).

**Cross-Platform Support**:
Yadm uses "alternates" to manage platform-specific configurations. Files with special suffixes are automatically symlinked based on your OS:
- `.zshrc##os.Darwin` → Used on macOS
- `.zshrc##os.Linux` → Used on Linux
- `.zshrc##os.Windows_NT` → Used on Windows (Git Bash/WSL)

**Common Commands**:

* `yadm status`: Check status of dotfiles.
* `yadm add <file>`: Track a new config file.
* `yadm commit -m "..."`: Save changes.
* `yadm push`: Upload to remote.
* `yadm alt`: Update alternate files (usually automatic).

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

### Homebrew (macOS only)

**Description**: The package manager for macOS system-level dependencies, GUI apps (Casks), and heavy tools not suitable for Mise.
**Configuration**: `~/.Brewfile` (List of installed packages).

**Common Commands**:

* **Install Dependencies**: `brew bundle --global` (Install everything in Brewfile).
* **Snapshot Current Setup**: `brew bundle dump --global --force --describe` (Update Brewfile with currently installed packages).
* **Cleanup**: `brew cleanup`.

### Scoop (Windows only)

**Description**: Command-line installer for Windows. Similar to Homebrew but for Windows.
**Configuration**: `~/.Scoopfile` (List of packages to install).
**Website**: https://scoop.sh/

**Installation**:
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
```

**Common Commands**:

* **Install a package**: `scoop install <package>`
* **Update Scoop**: `scoop update`
* **Update all packages**: `scoop update *`
* **Search for packages**: `scoop search <query>`
* **Add buckets**: `scoop bucket add extras` (for more packages)
* **Cleanup old versions**: `scoop cleanup *`

**Recommended Buckets**:
* `extras` - Additional useful apps
* `nerd-fonts` - Programming fonts with icons

**Alternative**: Windows also supports `winget` (built-in) and `chocolatey` as package managers.

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

---

## Platform-Specific Notes

### macOS

- **Homebrew**: Primary package manager for system tools and GUI apps
- **Shell**: zsh is the default shell (since macOS Catalina)
- **Paths**: Uses `/opt/homebrew` on Apple Silicon, `/usr/local` on Intel
- **Terminal**: iTerm2, WezTerm, or default Terminal.app recommended
- **Tmux**: Full support with auto-start on SSH

### Linux

- **Package Managers**: Distribution-specific (apt, dnf, pacman, etc.)
- **Shell**: Install zsh if not default: `sudo apt install zsh` or equivalent
- **Paths**: Standard Unix paths (`/usr/local/bin`, `/usr/bin`, etc.)
- **Terminal**: Most terminal emulators work (GNOME Terminal, Konsole, etc.)
- **Tmux**: Full support

### Windows

- **Environment**: Best with Git Bash (included with Git for Windows) or WSL
- **Package Manager**: Scoop (recommended) or winget
- **Shell**: 
  - **Git Bash**: Provides Unix-like environment on Windows
  - **WSL**: Full Linux environment (Ubuntu, Debian, etc.) - recommended for serious development
- **Paths**: Mixed Windows/Unix paths can be tricky
- **Terminal**: Windows Terminal (recommended) or Git Bash
- **Tmux**: 
  - Not available in Git Bash
  - Full support in WSL
- **Notes**:
  - Some Unix tools may not work in Git Bash
  - For best experience, use WSL 2 with these dotfiles
  - Git Credential Manager recommended for git authentication

### Choosing Between Git Bash and WSL on Windows

**Git Bash** (lighter, faster):
- Quick terminal access
- Good for basic git operations and shell commands
- Many Unix tools work via Git for Windows
- No tmux support

**WSL** (full Linux experience):
- Complete Linux environment
- All Unix tools work natively
- Full tmux support
- Better for serious development
- Requires Windows 10/11

## Troubleshooting

### Yadm alternates not working

Run `yadm alt` to manually trigger alternate file processing.

### Bootstrap fails on Windows

Make sure you're running Git Bash or WSL, not Command Prompt or PowerShell.

### mise commands not found after install

Restart your shell or run: `source ~/.zshrc` (Unix) or restart Git Bash (Windows).

### Scoop installation issues on Windows

You may need to change execution policy first:
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Contributing

Feel free to fork this repository and customize it for your own use! The cross-platform structure makes it easy to maintain separate configurations while sharing common tools.
