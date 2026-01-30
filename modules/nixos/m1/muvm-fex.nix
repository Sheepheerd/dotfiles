{
  pkgs,
  lib,
  config,
  ...
}:
let
  # 1. Vital Overrides for Asahi/Muvm Support
  # These are necessary because upstream Nixpkgs versions may be too old
  # or lack specific patches for Apple Silicon GPU support.
  muvm-fex-overlay = final: prev: {

    # Update libkrunfw (The kernel used by the VM)
    libkrunfw = prev.libkrunfw.overrideAttrs (old: rec {
      version = "5.1.0";
      src = final.fetchFromGitHub {
        owner = "containers";
        repo = "libkrunfw";
        tag = "v${version}";
        hash = "sha256-x9HQP+EqCteoCq2Sl/TQcfdzQC5iuE4gaSKe7tN5dAA=";
      };
      kernelSrc = final.fetchurl {
        url = "mirror://kernel/linux/kernel/v6.x/linux-6.12.62.tar.xz";
        hash = "sha256-E+LGhayPq13Zkt0QVzJVTa5RSu81DCqMdBjnt062LBM=";
      };
    });

    # Update libkrun (The hypervisor library)
    libkrun = prev.libkrun.overrideAttrs (old: rec {
      version = "1.17.0";
      src = final.fetchFromGitHub {
        owner = "containers";
        repo = "libkrun";
        tag = "v${version}";
        hash = "sha256-6HBSL5Zu29sDoEbZeQ6AsNIXUcqXVVGMk0AR2X6v1yU=";
      };
      cargoDeps = final.rustPlatform.fetchCargoVendor {
        inherit src;
        hash = "sha256-UIzbtBJH6aivoIxko1Wxdod/jUN44pERX9Hd+v7TC3Q=";
      };
      buildInputs = [ final.libkrunfw ] ++ final.lib.filter (i: i != prev.libkrunfw) old.buildInputs;
    });

    # Update virglrenderer (GPU acceleration)
    virglrenderer = prev.virglrenderer.overrideAttrs (old: {
      src = final.fetchurl {
        url = "https://gitlab.freedesktop.org/asahi/virglrenderer/-/archive/asahi-20250424/virglrenderer-asahi-20250806.tar.bz2";
        hash = "sha256-96qatlyDxn8IA8/WLH58XUwThDIzNOGpgXvDQ9/cqjA=";
      };
      mesonFlags = old.mesonFlags ++ [ (final.lib.mesonOption "drm-renderers" "asahi-experimental") ];
    });

    # 2. The Fedora RootFS Definition
    # This downloads the Fedora image that FEX will use inside the VM.
    fex-emu-rootfs-fedora = final.stdenv.mkDerivation rec {
      pname = "fex-emu-rootfs-fedora";
      version = "1.1.2-fc43";

      src = pkgs.fetchurl {
        url = "https://riscv-kojipkgs.fedoraproject.org//packages/fex-emu-rootfs-fedora/42%5E1.1/2.fc43/noarch/fex-emu-rootfs-fedora-42%5E1.1-2.fc43.noarch.rpm";
        sha256 = "sha256-xyN2yWi+1ErbCT/gynZFxrXjYdyUvEE76nfddotOPAQ=";
      };

      nativeBuildInputs = [
        final.rpm
        final.cpio
      ];

      unpackPhase = ''
        rpm2cpio $src | cpio -idmv
      '';

      installPhase = ''
        mkdir -p $out
        cp -r usr/share/fex-emu/RootFS $out/
      '';
    };
  };

  # 3. The Simple Runner
  # This points muvm purely to the Fedora image defined above.
  muvm-x86-runner = pkgs.writeShellScriptBin "muvm-x86-runner" ''
    exec ${pkgs.muvm}/bin/muvm \
      --fex-image "${pkgs.fex-emu-rootfs-fedora}/RootFS/default.erofs" \
      "$@"
  '';

in
{
  options.solarsystem = {
    muvm = lib.mkEnableOption "Asahi Linux muvm with Fedora RootFS";
  };

  config = lib.mkIf config.solarsystem.muvm {
    nixpkgs.overlays = [ muvm-fex-overlay ];

    environment.systemPackages = with pkgs; [
      muvm
      fex
      muvm-x86-runner

      # Tools needed for FEX image management
      fuse
      squashfuse
      squashfsTools
    ];
  };
}
