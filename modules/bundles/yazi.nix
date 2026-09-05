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
      p7zip
      poppler-utils
      resvg
      yazi
    ];

    xdg.configFile."yazi".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/yazi";

    programs.zsh.initContent = lib.mkOrder 1400 ''
      # Leave the shell in Yazi's last directory when quitting with `q`.
      y() {
        local tmp cwd yazi_status
        tmp="$(mktemp -t "yazi-cwd.XXXXXX")" || return

        command yazi "$@" --cwd-file="$tmp"
        yazi_status=$?

        IFS= read -r -d ''' cwd < "$tmp"
        command rm -f -- "$tmp"

        if [[ -n "$cwd" && "$cwd" != "$PWD" && -d "$cwd" ]]; then
          builtin cd -- "$cwd"
        fi

        return "$yazi_status"
      }
    '';
  };
}
