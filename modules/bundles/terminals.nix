{
  username,
  dotfilesDir,
  ...
}:
{
  homebrew.casks = [
    "claude"
    "chatgpt"
    "font-jetbrains-mono-nerd-font"
    "ghostty"
    "karabiner-elements"
    "orbstack"
    "raycast"
    "shottr"
    "visual-studio-code"
    "wezterm"
  ];

  home-manager.users.${username} = { config, ... }: {
    xdg.configFile = {
      "karabiner".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/karabiner";
      "wezterm".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/wezterm";
    };
  };
}
