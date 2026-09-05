{
  description = "uke's declarative macOS environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-homebrew,
      ...
    }:
    let
      username = "uke";
      hostname = "ukedeMacBook-Pro";
      dotfilesDir = "/Users/${username}/Documents/dotfiles";
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit
            inputs
            username
            hostname
            dotfilesDir
            ;
        };

        modules = [
          ./hosts/ukedeMacBook-Pro
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = {
                inherit
                  inputs
                  username
                  hostname
                  dotfilesDir
                  ;
              };
              users.${username} = import ./modules/home;
            };
          }
        ];
      };

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);

      devShells = forAllSystems (
        system:
        let
          systemPkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = systemPkgs.mkShell {
            packages = with systemPkgs; [
              actionlint
              nixfmt-tree
              shellcheck
              shfmt
              stylua
            ];
          };
        }
      );

      packages.aarch64-darwin.darwin-rebuild = nix-darwin.packages.aarch64-darwin.darwin-rebuild;

      checks.aarch64-darwin.configuration = self.darwinConfigurations.${hostname}.system;
    };
}
