{
  config,
  pkgs,
  username,
  ...
}:
{
  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
    stateVersion = "26.05";

    sessionPath = [
      "$HOME/.local/bin"
      "/Library/TeX/texbin"
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      HOMEBREW_NO_ANALYTICS = "1";
    };
  };

  xdg.enable = true;
  programs.home-manager.enable = true;

  programs.zsh.profileExtra = ''
    # Added by OrbStack: command-line tools and integration.
    source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
  '';
}
