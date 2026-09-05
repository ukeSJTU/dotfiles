{
  username,
  dotfilesDir,
  ...
}:
{
  homebrew = {
    taps = [ "bahaaio/pomo" ];
    casks = [ "pomo" ];
  };

  home-manager.users.${username} = { config, ... }: {
    xdg.configFile."pomo".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/pomo";
  };
}
