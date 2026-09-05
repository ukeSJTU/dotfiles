{
  lib,
  pkgs,
  username,
  dotfilesDir,
  ...
}:
{
  home-manager.users.${username} = { config, ... }: {
    home.packages = [ pkgs.mise ];

    home.file.".bunfig.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.bunfig.toml";
    xdg.configFile."mise".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/mise";

    programs.zsh = {
      profileExtra = lib.mkAfter ''
        eval "$(mise activate zsh --shims)"
      '';
      initContent = lib.mkBefore ''
        eval "$(mise activate zsh)"
      '';
    };
  };
}
