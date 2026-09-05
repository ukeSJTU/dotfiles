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
      # Karabiner writes downloaded complex-modification assets next to its
      # config, so manage only the file and keep the containing directory
      # mutable.
      "karabiner/karabiner.json".source =
        config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/karabiner/karabiner.json";
      "wezterm".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/wezterm";
    };
  };
}
