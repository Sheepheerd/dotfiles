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
    isLaptop = false;
    isNixos = true;
    isLinux = true;
    # sharescreen = "eDP-1";
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
  boot.supportedFilesystems = [ "ntfs" ];
  networking = {
    hostName = "deathstar";
    interfaces.eno1.wakeOnLan.enable = true;
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  solarsystem = lib.recursiveUpdate {
    # firewall = lib.mkForce true;
    # wallpaper = self + /files/wallpaper/lenovowp.png;
    hasBluetooth = true;
    # rootDisk = "/dev/nvme0n1";
    modules.youtube = true;
    modules.dolphin = true;
    modules.winboat = true;
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
      profiles = {
        nixvim = true;
      };
    } sharedOptions;
  };
}
