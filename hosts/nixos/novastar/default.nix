{
  lib,
  minimal,
  ...
}:
let
  mainUser = "sheep";
  # primaryUser = config.solarsystem.mainUser;
  sharedOptions = {
    inherit mainUser;
    isLaptop = true;
    isNixos = true;
    isLinux = true;
    sharescreen = "eDP-1";
    profiles = {
      reduced = lib.mkIf (!minimal) true;
      minimal = lib.mkIf minimal true;
    };
  };
in
{

  imports = [
    ./hardware-configuration.nix

  ];

  networking = {
    hostName = "novastar";
  };
  solarsystem = lib.recursiveUpdate {
    hasBluetooth = true;
    asahi = true;
    modules.box64Asahi = true;
    modules.virt = true;

    # FIX
    profiles = {
      # btrfs = true;
    };
  } sharedOptions;

  home-manager.users."${mainUser}" = {
    home.stateVersion = lib.mkForce "25.05";
    solarsystem = lib.recursiveUpdate {
    } sharedOptions;
  };
}
