{
  self,
  config,
  inputs,
  lib,
  minimal,
  ...
}:
let
  mainUser = "sheep";
  # primaryUser = config.solarsystem.mainUser;
  sharedOptions = {
    inherit mainUser;
    isLaptop = false;
    isNixos = true;
    isLinux = true;
    # sharescreen = "eDP-1";
    profiles = {
      server = true;
    };
  };
in
{

  imports = [
    ./hardware-configuration.nix

  ];

  networking = {
    hostName = "solis";
  };

  solarsystem = lib.recursiveUpdate {
    modules.firewall = lib.mkForce true;
    # wallpaper = self + /files/wallpaper/lenovowp.png;
    hasBluetooth = false;
    # rootDisk = "/dev/nvme0n1";

    # FIX
    profiles = {
      # btrfs = true;
    };
  } sharedOptions;

  home-manager.users."${mainUser}" = {
    home.stateVersion = lib.mkForce "25.11";
    solarsystem = lib.recursiveUpdate {
      # lowResolution = "1280x800";
      # highResolution = "1920x1080";
    } sharedOptions;
  };
}
