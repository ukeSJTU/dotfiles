{
  pkgs,
  username,
  ...
}:
{
  nix = {
    package = pkgs.lix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    optimise.automatic = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  system = {
    primaryUser = username;
    stateVersion = 6;
  };

  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];
}
