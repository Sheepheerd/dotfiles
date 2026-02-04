{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  matlabScript = pkgs.writeShellScriptBin "matlab" ''
    #!/usr/bin/env bash
    set -euo pipefail
    distrobox enter steam -- muvm -- FEXBash "/home/sheep/matlab/bin/matlab"
  '';
in
{
  options.solarsystem.modules.box = lib.mkEnableOption "Install scripts for Asahi Fedora Steam Distrobox and MATLAB launcher";

  config = lib.mkIf config.solarsystem.modules.box {
    environment.systemPackages = [
      matlabScript
      pkgs.distrobox
      # pkgs.muvm
      # pkgs.muvm
    ];
    # services.envfs.enable = true;
    # environment.sessionVariables.ENVFS_RESOLVE_ALWAYS = "1";
    # services.flatpak.enable = true;
    #
    programs.nix-ld.enable = lib.mkDefault true;
    environment.variables.LD_LIBRARY_PATH = lib.mkForce "";
    # These libararies doesn't need to be configured in NIX_LD_LIBRARY_PATH
    # and auto-configured
    programs.nix-ld.libraries =
      with pkgs;
      [
        acl
        attr
        bzip2
        dbus
        expat
        fontconfig
        freetype
        fuse3
        icu
        libnotify
        libsodium
        libssh
        libunwind
        libusb1
        libuuid
        nspr
        nss
        stdenv.cc.cc
        util-linux
        zlib
        zstd
      ]
      ++ lib.optionals (config.hardware.graphics.enable) [
        pipewire
        cups
        libxkbcommon
        pango
        mesa
        libdrm
        libglvnd
        libpulseaudio
        atk
        cairo
        alsa-lib
        at-spi2-atk
        at-spi2-core
        gdk-pixbuf
        glib
        gtk3
        libGL
        libappindicator-gtk3
        vulkan-loader
      ];
  };

}
