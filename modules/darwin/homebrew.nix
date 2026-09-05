{
  config,
  lib,
  username,
  ...
}:
{
  # nix-homebrew owns Homebrew itself; nix-darwin owns its package manifest.
  nix-homebrew = {
    enable = true;
    user = username;
    autoMigrate = true;
    enableRosetta = false;
    mutableTaps = true;
  };

  homebrew = {
    enable = true;
    user = username;

    global = {
      autoUpdate = true;
      brewfile = true;
    };

    onActivation = {
      autoUpdate = false;
      upgrade = false;

      # Preserve software installed outside this configuration instead of
      # treating the declared cask and shell bundle as an exclusive set.
      cleanup = "none";

      extraEnv = {
        HOMEBREW_NO_ANALYTICS = "1";
      };
    };
  };

  # nix-homebrew moves Homebrew's code into the Nix store when migrating an
  # existing installation. Repair the legacy completion link if it still
  # points at the old repository layout.
  system.activationScripts.homebrew.text = lib.mkAfter ''
    brew_completion="/opt/homebrew/share/zsh/site-functions/_brew"
    if [[ -L "$brew_completion" && ! -e "$brew_completion" ]]; then
      /bin/ln -sfn ${config.nix-homebrew.package}/completions/zsh/_brew "$brew_completion"
    fi
  '';
}
