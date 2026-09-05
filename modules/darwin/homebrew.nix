{ username, ... }:
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

      # Keep imperative packages during the migration. Change this to
      # "check" first, then "uninstall", once every formula has moved.
      cleanup = "none";

      extraEnv = {
        HOMEBREW_NO_ANALYTICS = "1";
      };
    };
  };
}
