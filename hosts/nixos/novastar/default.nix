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
    # info = "Apple M1";
    # firewall = lib.mkForce true;
    # wallpaper = self + /files/wallpaper/lenovowp.png;
    hasBluetooth = true;
    asahi = true;

    modules.sunshine = false;
    modules.steam = false;
    modules.minecraft = false;
    # rootDisk = "/dev/nvme0n1";

    # FIX
    profiles = {
      # btrfs = true;
    };
  } sharedOptions;

  home-manager.users."${mainUser}" = {
    home.stateVersion = lib.mkForce "25.05";
    solarsystem = lib.recursiveUpdate {
      # lowResolution = "1280x800";
      # highResolution = "1920x1080";
    } sharedOptions;
  };
}
