{
  config,
  lib,
  ...
}:

{
  options.solarsystem = {
    x86 = lib.mkEnableOption "x86 emulation";
  };

  config = lib.mkIf config.solarsystem.x86 {

    # Currently the build for qemu-user-static fails with
    # relocation truncated to fit: R_AARCH64_LD64_GOTPAGE_LO15 against symbol `_nettle_aes256_decrypt_arm64'
    # warning: too many GOT entries for -fpic, please recompile with -fPIC
    # So we create an overlay with following

    # We override 'pkgsStatic' to inject a modified 'qemu-user' that uses our fixed 'nettle'.
    # This leaves the global 'nettle' and other static packages untouched.
    # https://github.com/NixOS/nixpkgs/issues/392673
    nixpkgs.overlays = [
      (final: previous: {
        # https://github.com/NixOS/nixpkgs/issues/392673
        # aarch64-unknown-linux-musl-ld: (.text+0x484): warning: too many GOT entries for -fpic, please recompile with -fPIC
        nettle = previous.nettle.overrideAttrs (
          lib.optionalAttrs final.stdenv.hostPlatform.isStatic {
            CCPIC = "-fPIC";
          }
        );
      })
      # https://github.com/NixOS/nixpkgs/issues/366902
      (final: prev: {
        qemu-user = prev.qemu-user.overrideAttrs (
          old:
          lib.optionalAttrs final.stdenv.hostPlatform.isStatic {
            configureFlags = old.configureFlags ++ [ "--disable-pie" ];
          }
        );
      })
    ];

    # Test if it works with following
    # nix-shell -p hello --argstr system aarch64-linux --run "hello"
    boot.binfmt.emulatedSystems = [
      "x86_64-linux"
      "i686-linux"
    ];
    # boot.kernel.sysctl."kernel.unprivileged_userns_clone" = 1;
    # Use statically-linked QEMU binaries, often necessary for Docker/Podman
    # or chroot envs (like flatpak)
    # Note: This might trigger a local build of QEMU if pre-built binaries aren't cached
    # 1. This installs qemu-user-static
    # 2. Set the emulator as Fixed (check: cat /proc/sys/fs/binfmt_misc/x86_64-linux)
    boot.binfmt.preferStaticEmulators = true;

    # Whether to add the boot.binfmt.emulatedSystems to nix.settings.extra-platforms
    # Disable this to use remote builders for those platforms,
    # while allowing testing binaries locally.
    # boot.binfmt.addEmulatedSystemsToNixSandbox = true;

  };

}
