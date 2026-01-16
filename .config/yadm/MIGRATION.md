# Migration Guide: Transitioning to Cross-Platform Dotfiles

If you were using this dotfiles repository before it became cross-platform, this guide will help you migrate smoothly.

## What Changed?

### Before (macOS-only)
- Single `.zshrc` file for macOS
- Single `.zshenv` file with macOS-specific paths
- Single `.gitconfig` with macOS credential helper
- Bootstrap script assumed macOS + Homebrew

### After (Cross-Platform)
- Platform-specific alternates: `.zshrc##os.{Darwin,Linux,Windows_NT}`
- Platform-specific environment files: `.zshenv##os.{Darwin,Linux,Windows_NT}`
- Platform-specific git configs: `.gitconfig##os.{Darwin,Linux,Windows_NT}`
- Smart bootstrap script that detects OS
- Added `.Scoopfile` for Windows package management

## Migration Steps

### For Existing macOS Users

If you already have this dotfiles repo installed on macOS:

```bash
# 1. Pull the latest changes
yadm pull

# 2. Process alternates (creates symlinks automatically)
yadm alt -v

# 3. Verify the correct files are linked
ls -la ~/.zshrc
# Should point to: .zshrc##os.Darwin

ls -la ~/.zshenv  
# Should point to: .zshenv##os.Darwin

ls -la ~/.gitconfig
# Should point to: .gitconfig##os.Darwin

# 4. Restart your shell or source the new config
source ~/.zshrc

# 5. Everything should work as before!
```

### For New Windows Setup

If you want to use these dotfiles on a Windows machine:

```bash
# 1. Install prerequisites (in PowerShell as Administrator)
winget install Git.Git
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
scoop install yadm

# 2. Open Git Bash and clone the dotfiles
yadm clone https://github.com/ukeSJTU/dotfiles.git --no-bootstrap

# 3. Verify alternates were processed
yadm alt -v
ls -la ~/.zshrc  # Should point to .zshrc##os.Windows_NT

# 4. Run bootstrap to install tools
yadm bootstrap

# 5. Restart Git Bash
```

### For New Linux Setup

```bash
# 1. Install yadm
# Ubuntu/Debian:
sudo apt install yadm
# Arch:
sudo pacman -S yadm
# Fedora:
sudo dnf install yadm

# 2. Clone dotfiles
yadm clone https://github.com/ukeSJTU/dotfiles.git --no-bootstrap

# 3. Verify alternates
yadm alt -v
ls -la ~/.zshrc  # Should point to .zshrc##os.Linux

# 4. Run bootstrap
yadm bootstrap

# 5. Restart shell
exec zsh
```

## Handling Conflicts

### Conflict 1: Existing non-alternate files

If you have existing `.zshrc` or `.gitconfig` that aren't tracked by yadm:

```bash
# Backup your current files
mv ~/.zshrc ~/.zshrc.backup
mv ~/.zshenv ~/.zshenv.backup
mv ~/.gitconfig ~/.gitconfig.backup

# Let yadm create the correct symlinks
yadm alt

# Compare and merge if needed
diff ~/.zshrc.backup ~/.zshrc
```

### Conflict 2: Custom local changes

If you made local customizations:

```bash
# 1. Save your changes before pulling
yadm diff > ~/my-dotfiles-changes.patch

# 2. Pull the updates
yadm pull

# 3. Reapply your changes
# Edit the appropriate OS-specific file:
# macOS: edit .zshrc##os.Darwin
# Linux: edit .zshrc##os.Linux  
# Windows: edit .zshrc##os.Windows_NT

# 4. Or use .zshrc.local for truly local changes
echo "# My local customizations" >> ~/.zshrc.local
```

### Conflict 3: Platform-specific customizations

If you have platform-specific tweaks:

```bash
# Good practice: Use .local files that are NOT tracked by yadm
# These files are sourced automatically if they exist:

# Shell: ~/.zshrc.local or ~/.zshenv.local
# Git: ~/.gitconfig.local (needs to be included in .gitconfig)

# Example:
echo "export MY_CUSTOM_VAR=value" >> ~/.zshrc.local
```

## Verification Checklist

After migration, verify:

- [ ] `yadm status` shows clean (no uncommitted changes)
- [ ] `.zshrc` is a symlink to the OS-specific version
- [ ] `.zshenv` is a symlink to the OS-specific version  
- [ ] `.gitconfig` is a symlink to the OS-specific version
- [ ] Shell starts without errors: `zsh -c 'echo ok'`
- [ ] Git config loads: `git config --list`
- [ ] mise works: `mise list`
- [ ] starship prompt appears
- [ ] Custom aliases still work

## Rolling Back

If something goes wrong and you need to roll back:

```bash
# 1. Check out the previous commit
yadm log  # Find the commit hash before the update
yadm checkout <commit-hash>

# 2. Or reset to a specific file version
yadm checkout HEAD~1 -- .zshrc

# 3. Process alternates again
yadm alt
```

## FAQ

**Q: Will my existing Brewfile still work?**  
A: Yes! The `.Brewfile` is only used on macOS. The bootstrap script detects your OS and only runs `brew bundle` on macOS.

**Q: Do I need to modify my existing customizations?**  
A: Probably not. The OS-specific versions are very similar. The main differences are in PATH setup and platform-specific tools.

**Q: Can I still add new dotfiles like before?**  
A: Yes! Use `yadm add <file>` as before. If you need platform-specific versions, create alternates: `yadm add .myfile##os.Darwin`

**Q: What if I use multiple machines with different OSes?**  
A: Perfect! That's what this is for. Clone the repo on each machine and yadm will automatically use the right files for each OS.

**Q: Can I combine multiple conditions (OS + hostname)?**  
A: Yes! Yadm supports multiple conditions: `.zshrc##os.Darwin,hostname.macbook-pro`

**Q: How do I know which file yadm is using?**  
A: Run `yadm alt -v` to see all alternates. Or check: `ls -la ~/.zshrc` to see the symlink target.

## Getting Help

If you encounter issues:

1. Check the logs: `yadm alt -v`
2. Read the testing guide: `.config/yadm/TESTING.md`
3. Check yadm docs: https://yadm.io/docs/alternates
4. File an issue with details about your OS and error messages

## Tips for Smooth Migration

1. **Test on a VM first**: If possible, test the migration on a virtual machine before applying to your main system
2. **Backup everything**: `yadm encrypt` can help backup sensitive configs
3. **Go step by step**: Don't run `yadm bootstrap` until you've verified the alternates are correct
4. **Use .local files**: Keep truly local customizations in `.zshrc.local` (not tracked)
5. **Document your changes**: If you customize the OS-specific files, add comments explaining why
