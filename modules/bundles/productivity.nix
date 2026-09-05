{
  username,
  dotfilesDir,
  ...
}:
{
  homebrew = {
    taps = [
      {
        name = "bahaaio/pomo";
        trusted = true;
      }
    ];
    casks = [ "pomo" ];
  };

  home-manager.users.${username} = { config, ... }: {
    xdg.configFile."pomo".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/pomo";
  };
}
