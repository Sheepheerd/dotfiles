{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  # pkgsX86 = import inputs.nixpkgs {
  #   system = "x86_64-linux";
  #   config.allowUnfree = true;
  # };
  # pkgsStable = import inputs.nixpkgs-stable {
  #   system = "aarch64-linux";
  #   config.allowUnfree = true;
  # };
  muvm-fex-overlay = final: prev: {

    # Update to libkrunfw to 5.1.0 (Required for libkrun 1.17.0)
    libkrunfw = prev.libkrunfw;
    # Update to libkrun to 1.17.0
    libkrun = prev.libkrun;
    fex = prev.fex;

    # Override muvm: Use latest libkrun

    muvm =
      (prev.muvm.override {
        libkrun = final.libkrun;
      }).overrideAttrs
        (oldAttrs: rec {
          version = "0.5.0-fork";
          src = final.fetchFromGitHub {
            owner = "zeronone";
            repo = "muvm";
            rev = "main";
            hash = "sha256-52mcVx/ofmuAyOOTnezQGtkbw3gqF32fwNKX5vMIffk=";
          };

          # Cargo dependencies will change with the new version
          cargoDeps = final.rustPlatform.fetchCargoVendor {
            inherit src;
            hash = "sha256-Rx98pDO2NR2BYp6eJMrqQ9n4J8+1pnMBy886cZCEFBo=";
          };

          # We must patch muvm to look in /run/current-system/...
          # The default behavior looks in the immutable ${fex}/share path.
          postPatch = (oldAttrs.postPatch or "") + ''
            # Replace the store path (or default path) with the NixOS system path

            # Faulty replacement in nixpkgs
            substituteInPlace crates/muvm/src/guest/mount.rs \
              --replace-fail "${final.fex}/share/fex-emu" "/usr/share/fex-emu"

            # Used for auto-discovery of RootFS images
            # substituteInPlace crates/muvm/src/bin/muvm.rs \
            #   --replace-fail "/usr/share/fex-emu" "/run/current-system/sw/share/fex-emu"

            # substituteInPlace crates/muvm/src/bin/muvm.rs \
            #   --replace-fail "/usr/local/share/fex-emu" "/run/current-system/sw/share/fex-emu"
            #   --replace-fail "${final.fex}/share/fex-emu" "/usr/share/fex-emu"
          '';
        });
  };

  # Helper method to create mesa erofs
  makeMesaErofs =
    {
      name,
      mesaPkg,
      libDir,
    }:
    pkgs.runCommand "${name}.erofs"
      {
        nativeBuildInputs = [ pkgs.erofs-utils ];
      }
      ''
        mkdir -p root/usr/${libDir}

        # Use --no-preserve=mode so the copied files are writable.
        # Use -f to force overwrite if a file already exists.

        # Copy libraries
        cp -L -r -f --no-preserve=mode ${mesaPkg}/lib/* root/usr/${libDir}/

        mkdir -p $out/share/fex-emu/overlays
        mkfs.erofs -zlz4hc $out/share/fex-emu/overlays/${name}.erofs root
      '';

  # The Mesa Images (x86_64 and i386)
  # We combine them into one derivation for cleaner systemPackages handling,
  # but they could be separate if preferred.
  mesaAssets = pkgs.symlinkJoin {
    name = "fex-mesa-assets";
    paths = [
      (makeMesaErofs {
        name = "mesa-x86_64";
        mesaPkg = pkgs.pkgsCross.gnu64.mesa;
        # mesaPkg = pkgsX86.mesa;
        libDir = "lib64";
      })
      (makeMesaErofs {
        name = "mesa-i386";
        mesaPkg = pkgs.pkgsCross.gnu32.mesa;
        # mesaPkg = pkgsX86.pkgsi686Linux.mesa;
        libDir = "lib";
      })
    ];
  };

  fexRootFS = pkgs.stdenv.mkDerivation rec {
    pname = "fex-emu-rootfs-fedora";
    version = "1.1.2-fc43";

    src = pkgs.fetchurl {
      url = "https://riscv-kojipkgs.fedoraproject.org//packages/fex-emu-rootfs-fedora/42%5E1.1/2.fc43/noarch/fex-emu-rootfs-fedora-42%5E1.1-2.fc43.noarch.rpm";
      sha256 = "sha256-xyN2yWi+1ErbCT/gynZFxrXjYdyUvEE76nfddotOPAQ=";
    };

    # Required tools
    nativeBuildInputs = [
      pkgs.rpm
      pkgs.cpio
      pkgs.autoPatchelfHook
    ];

    unpackPhase = ''
      # Extract the RPM content
      rpm2cpio $src | cpio -idmv
    '';

    installPhase = ''
      # Install to the shared system path structure
      mkdir -p $out/share/fex-emu/RootFS
      cp usr/share/fex-emu/RootFS/default.erofs $out/share/fex-emu/RootFS/
    '';
  };
in
{
  options.solarsystem = {
    muvm = lib.mkEnableOption "Asahi Linux muvm";
  };

  config = lib.mkIf config.solarsystem.muvm {
    # Background
    # https://docs.fedoraproject.org/en-US/fedora-asahi-remix/x86-support/

    # What does muvm do?
    # 1. Creates a MicroVM: Launches a libkrun-based virtual machine running a 4K-page Linux kernel to
    #    bypass the 16K-page incompatibility of the Apple Silicon host.
    # 2. Mirrors Host Filesystem: Mounts the host's root filesystem inside the VM (sharing /usr, /home, etc.)
    #    while keeping specific directories like /dev and /run private to the guest.
    # 3. Enables Emulation: Configures the guest's binfmt_misc to automatically run x86/x86-64 binaries
    #    using FEX-emu (leveraging hardware TSO for performance).
    # 4. Manages RootFS: Mounts a custom FEX root filesystem and overlays at /run/fex-emu/
    #    to provide necessary x86/x86-64 shared libraries.
    # 5. Bridges Hardware/Audio: Implements pass-through for the GPU (native context), X11,
    #    PulseAudio, and input devices to integrate seamlessly with the host desktop.

    # Virtualization: Host (aarch64) -> muvm (4k kernel) -> FEX -> x86 binary

    # Debugging
    # Checking if muvm works
    #   muvm -- getconf PAGESIZE
    #   muvm -- ls -l /proc/sys/fs/binfmt_misc  # Check binfmt is configured to FEX inside muvm
    #   muvm -- mount     # run aarch64 binaries inside muvm 4k kernel

    # Run aarch64 binaries with 4K pagesize kernel
    #   muvm -- ls -l /

    # Run normal x86 binaries
    #   muvm -- $(nix build nixpkgs#legacyPackages.x86_64-linux.hello --print-out-paths --no-link)/bin/hello

    # It is same as below
    #   muvm -- FEX $(nix build nixpkgs#legacyPackages.x86_64-linux.coreutils --print-out-paths --no-link)/bin/ls -l /

    # Running x86 binaries with GPU support inside fedora
    #   muvm -- flatpak run --verbose --arch=x86_64 com.discordapp.Discord

    # Overlay on pkgs-stable, as our mesa driver comes from there
    nixpkgs.overlays = [ muvm-fex-overlay ];

    # FEXBash assumes /bin/bash to exist
    # services.envfs.enable = true;

    # Install necessary deps
    environment.systemPackages = with pkgs; [
      # Needed by FEXRootFSFetcher
      # fuse
      # squashfuse
      # squashfsTools

      # RootFS
      fexRootFS
      mesaAssets

      # Main deps
      muvm
      fex

      # utils needed
      socat
    ];

    # This tells NixOS to symlink the contents of share/fex-emu
    # from all systemPackages into /run/current-system/sw/share/fex-emu
    environment.pathsToLink = [ "/share/fex-emu" ];
  };
}
