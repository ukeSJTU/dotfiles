# Testing Cross-Platform Dotfiles Setup

This guide helps you test that the cross-platform dotfiles are working correctly on your system.

## Pre-Installation Testing

### 1. Check System Detection

The bootstrap script detects your OS automatically. Test it:

```bash
# Run the OS detection part
case "$(uname -s)" in
    Darwin*)
        echo "Detected: macOS"
        ;;
    Linux*)
        echo "Detected: Linux"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        echo "Detected: Windows"
        ;;
    *)
        echo "Unknown OS"
        ;;
esac
```

Expected output: Your current operating system name.

## Post-Installation Testing

After running `yadm clone` and `yadm bootstrap`, test the following:

### 2. Check Yadm Alternates

Verify that yadm created the correct symlinks:

```bash
# Check which version of .zshrc is linked
ls -la ~/.zshrc
# Should point to .zshrc##os.Darwin (macOS), .zshrc##os.Linux (Linux), or .zshrc##os.Windows_NT (Windows)

# List all alternate files
yadm list -a | grep "##"

# Manually trigger alternate processing (should show which files are linked)
yadm alt -v
```

### 3. Verify Bootstrap Script Execution

Check that core tools were installed:

```bash
# Starship
starship --version
# Expected: Starship vX.X.X

# mise
mise --version  
# Expected: mise X.X.X

# Platform-specific package manager
# macOS:
brew --version
# Windows:
scoop --version
# Linux: depends on distribution
```

### 4. Test Shell Configuration

```bash
# Source the shell config
source ~/.zshrc

# Verify mise is loaded
which mise
mise list

# Verify starship prompt is loaded
which starship
echo $STARSHIP_CONFIG
# Expected: /Users/username/.config/starship.toml or similar

# Check that custom aliases work (if any are defined)
alias | grep -E "(ll|lg)"
```

### 5. Test Git Configuration

```bash
# Check git config is loaded
git config --get user.name
git config --get user.email

# Check platform-specific credential helper
git config --get credential.helper

# Expected:
# macOS: /usr/local/share/gcm-core/git-credential-manager
# Linux: cache --timeout=3600
# Windows: manager

# Test delta pager
git config --get core.pager
# Expected: delta
```

### 6. Test Development Tools (via mise)

```bash
# List all installed tools
mise list

# Test specific tools
node --version
python --version
go version
rustc --version

# Test modern CLI tools
eza --version  # or ls replacement
rg --version   # ripgrep
fd --version   # fd-find
bat --version  # cat replacement
```

### 7. Platform-Specific Tests

#### macOS
```bash
# Test Homebrew bundle
brew bundle check --global
# Expected: All dependencies are satisfied

# Check Homebrew packages
brew list
```

#### Windows (Git Bash/WSL)
```bash
# Test Scoop packages
scoop list
# Expected: List of installed packages

# Check Windows-specific settings
git config --get core.autocrlf
# Expected: true
```

#### Linux
```bash
# Check if tmux auto-start works (if configured)
# SSH into the machine and check if tmux starts automatically

# Verify system package manager is accessible
# Ubuntu/Debian:
dpkg -l | grep git
# Fedora/RHEL:
rpm -qa | grep git
# Arch:
pacman -Q | grep git
```

## Troubleshooting Tests

### Test Alternate Files Manually

```bash
# Show which alternates yadm would process
yadm config local.os
uname -s

# See what alternates exist
find ~ -maxdepth 1 -name "*##*" 2>/dev/null

# Force alternate processing
yadm alt -v
```

### Test Bootstrap Script Without Installation

```bash
# Dry-run the OS detection
bash -c '
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*) echo "linux" ;;
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
        *) echo "unknown" ;;
    esac
}
detect_os
'
```

### Check for Missing Dependencies

```bash
# Essential commands that should be available
command -v git || echo "git missing"
command -v curl || echo "curl missing"
command -v mise || echo "mise missing"
command -v starship || echo "starship missing"

# Shell-specific
command -v zsh || echo "zsh missing (required)"
```

## Success Criteria

✅ All of the following should be true:

1. `yadm alt` runs without errors
2. `.zshrc` is a symlink to the correct OS-specific version
3. `mise list` shows installed programming languages
4. `starship --version` returns a version number
5. Git configuration loads without errors
6. Platform-specific package manager works (brew/scoop/apt/etc.)
7. Shell prompt appears with starship formatting
8. Custom aliases and configurations load correctly

## Reporting Issues

If any tests fail, please check:

1. Run `yadm alt -v` to see alternate processing details
2. Check file permissions: `ls -la ~/.zshrc ~/.zshenv`
3. Verify yadm version: `yadm --version` (should be 3.x or higher)
4. Check bootstrap logs for errors
5. Ensure all prerequisite tools are installed

## Performance Testing

```bash
# Test shell startup time
time zsh -i -c exit
# Should be < 1 second

# Test mise activation time  
time zsh -i -c 'mise list'
# Should be < 2 seconds
```

## Cleanup After Testing

If you want to start fresh:

```bash
# Remove yadm
yadm untrack "*"  # Stop tracking all files
rm -rf ~/.local/share/yadm  # Remove yadm data

# Or to completely remove dotfiles:
# WARNING: This will delete your configurations!
# yadm decrypt  # if you encrypted anything
# cd ~ && yadm delete  # Remove yadm repository
```
