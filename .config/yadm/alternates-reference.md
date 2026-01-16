# Yadm Alternates Reference

This dotfiles repository uses yadm's "alternates" feature to manage platform-specific configurations.

## How Alternates Work

Yadm automatically links the appropriate version of a file based on your system. Files with special suffixes are used:

### Platform-Specific Files

- `filename##os.Darwin` - Used on macOS
- `filename##os.Linux` - Used on Linux  
- `filename##os.Windows_NT` - Used on Windows (Git Bash/WSL reports as Windows_NT)

### Example

When you have:
```
.zshrc##os.Darwin
.zshrc##os.Linux
.zshrc##os.Windows_NT
```

Yadm will automatically create a symlink from `.zshrc` to the correct version for your OS.

## Files Using Alternates in This Repo

### Shell Configuration
- `.zshenv##os.{Darwin,Linux,Windows_NT}` - Environment variables and paths
- `.zshrc##os.{Darwin,Linux,Windows_NT}` - Shell configuration and plugins

### Git Configuration
- `.gitconfig##os.{Darwin,Linux,Windows_NT}` - Git settings with platform-specific credential helpers

## Platform-Specific Package Files

- `.Brewfile` - macOS packages (Homebrew)
- `.Scoopfile` - Windows packages (Scoop)
- Linux: Distribution-specific (apt, dnf, pacman)

## Manual Alternate Processing

Yadm automatically processes alternates, but you can manually trigger it:

```bash
yadm alt
```

This is useful after:
- Cloning the repository
- Adding new alternate files
- Changing systems

## Creating New Alternates

To make a file platform-specific:

1. Create versions with appropriate suffixes:
   ```bash
   yadm mv .myfile .myfile##os.Darwin
   yadm add .myfile##os.Linux
   yadm add .myfile##os.Windows_NT
   ```

2. Yadm will handle the rest automatically

## Other Alternate Conditions

Yadm supports many conditions besides OS:

- `##class.<class>` - For different machine types (work, home, etc.)
- `##hostname.<hostname>` - For specific machines
- `##user.<username>` - For different users
- `##arch.<arch>` - For different architectures (x86_64, arm64, etc.)

Example: `.zshrc##os.Darwin,hostname.macbook-pro`

## Learn More

Official documentation: https://yadm.io/docs/alternates
