{
  lib,
  pkgs,
  username,
  ...
}:
{
  # These plugins remain Homebrew formulae for now because their layouts are
  # macOS-oriented and the existing hand-tuned load order is known-good.
  homebrew.brews = [
    "forgit"
    "fzf"
    "fzf-tab"
    "zsh-autosuggestions"
    "zsh-completions"
    "zsh-history-substring-search"
    "zsh-syntax-highlighting"
    "zsh-you-should-use"
  ];

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      bat
      direnv
      eza
      fd
      tealdeer
      zoxide
    ];

    programs.zsh = {
      enable = true;
      enableCompletion = false;
      initContent = lib.mkMerge [
        (lib.mkOrder 1000 (builtins.readFile ../../.zshrc))
        (lib.mkOrder 2000 ''
          # Keep direnv last so later integrations cannot clobber its PATH.
          eval "$(direnv hook zsh)"
        '')
      ];
    };
  };
}
