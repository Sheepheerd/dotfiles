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
  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
  solarsystem = lib.recursiveUpdate {
    hasBluetooth = true;
    asahi = true;

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
