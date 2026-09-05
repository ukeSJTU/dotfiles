{
  lib,
  pkgs,
  username,
  dotfilesDir,
  ...
}:
{
  home-manager.users.${username} = { config, ... }: {
    home.packages = with pkgs; [
      actionlint
      delta
      gh
      git
      git-lfs
      glow
      go-task
      jq
      just
      lazygit
      ripgrep
      shellcheck
      shfmt
    ];

    home.file = {
      ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.gitconfig";
      ".gitignore_global".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.gitignore_global";
    };

    xdg.configFile = {
      "lazygit".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/lazygit";
      "zsh".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/zsh";
    };

    programs.zsh.initContent = lib.mkOrder 1300 ''
      # Vendored git aliases (gst, gc, gco, ...).
      if [[ -r "$XDG_CONFIG_HOME/zsh/plugins/git.plugin.zsh" ]]; then
        source "$XDG_CONFIG_HOME/zsh/plugins/git.plugin.zsh"
      fi
    '';
  };
}
