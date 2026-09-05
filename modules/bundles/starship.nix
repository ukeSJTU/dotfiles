{
  lib,
  pkgs,
  username,
  dotfilesDir,
  ...
}:
{
  home-manager.users.${username} = { config, ... }: {
    home.packages = [ pkgs.starship ];

    xdg.configFile."starship.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/starship.toml";

    programs.zsh.initContent = lib.mkOrder 1400 ''
      eval "$(starship init zsh)"
    '';
  };
}
