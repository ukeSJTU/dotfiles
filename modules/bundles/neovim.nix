{
  pkgs,
  username,
  dotfilesDir,
  ...
}:
{
  home-manager.users.${username} = { config, ... }: {
    home.packages = with pkgs; [
      neovim
      stylua
      tree-sitter
    ];

    # Keep this mutable so :Lazy sync can update lazy-lock.json in the repo.
    xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/nvim";
  };
}
