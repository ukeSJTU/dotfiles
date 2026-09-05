{
  pkgs,
  username,
  ...
}:
{
  nix = {
    # Lix provides the reversible bootstrap; nix-darwin then follows the
    # upstream Nix build pinned by nixpkgs.
    package = pkgs.nix;
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

  # On this macOS release, creating a symlink in /etc/pam.d blocks inside the
  # kernel. We do not enable sudo Touch ID, and macOS already treats
  # sudo_local as optional, so leave this Apple-managed path alone.
  security.pam.services.sudo_local.enable = false;
}
