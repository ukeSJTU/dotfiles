{
  lib,
  pkgs,
  username,
  dotfilesDir,
  ...
}:
{
  # Use the official release until nixpkgs catches up, keeping mise Nix-managed.
  nixpkgs.overlays = [
    (final: prev: {
      mise = final.stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "mise";
        version = "2026.9.11";

        src = final.fetchurl {
          url = "https://github.com/jdx/mise/releases/download/v${finalAttrs.version}/mise-v${finalAttrs.version}-macos-${
            if final.stdenv.hostPlatform.isAarch64 then "arm64" else "x64"
          }.tar.gz";
          hash =
            {
              aarch64-darwin = "sha256-NOgpb5MsHW87hNkku7nyhBM2177hw3MAXUeeE2ZMtsA=";
              x86_64-darwin = "sha256-RqZ7BQ1T8e55U1P4/17P15MoofZBX0s+3nns2nIj+Wk=";
            }
            .${final.stdenv.hostPlatform.system};
        };

        nativeBuildInputs = [ final.installShellFiles ];
        dontBuild = true;
        dontStrip = true;

        installPhase = ''
          runHook preInstall

          install -Dm755 bin/mise "$out/bin/mise"
          installManPage man/man1/mise.1

          export HOME="$TMPDIR/mise-home"
          export MISE_OFFLINE=1
          mkdir -p "$HOME"
          installShellCompletion --cmd mise \
            --bash <("$out/bin/mise" --no-config completion bash) \
            --fish <("$out/bin/mise" --no-config completion fish) \
            --zsh <("$out/bin/mise" --no-config completion zsh)

          mkdir -p "$out/lib/mise"
          touch "$out/lib/mise/.disable-self-update"

          runHook postInstall
        '';

        doInstallCheck = true;
        installCheckPhase = ''
          runHook preInstallCheck
          "$out/bin/mise" --no-config version | grep -F '${finalAttrs.version}'
          runHook postInstallCheck
        '';

        meta = prev.mise.meta // {
          changelog = "https://github.com/jdx/mise/releases/tag/v${finalAttrs.version}";
          platforms = lib.platforms.darwin;
          sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
        };
      });
    })
  ];

  home-manager.users.${username} = { config, ... }: {
    home.packages = [ pkgs.mise ];

    home.file.".bunfig.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.bunfig.toml";
    xdg.configFile."mise".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/mise";

    programs.zsh = {
      profileExtra = lib.mkAfter ''
        eval "$(mise activate zsh --shims)"
      '';
      initContent = lib.mkBefore ''
        eval "$(mise activate zsh)"
      '';
    };
  };
}
