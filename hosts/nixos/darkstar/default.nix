{
  lib,
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
    # sharescreen = "eDP-1";
    profiles = {
      minimal = true;
    };
  };
in
{

  imports = [
    ./hardware-configuration.nix
  ];
  boot.supportedFilesystems = [ "ntfs" ];
  networking = {
    hostName = "darkstar";
  };

  solarsystem = lib.recursiveUpdate {
    hasBluetooth = true;
    modules.youtube = true;
    modules.dolphin = true;
  } sharedOptions;

  home-manager.users."${mainUser}" = {
    home.stateVersion = lib.mkForce "26.05";
    solarsystem = lib.recursiveUpdate {
      # lowResolution = "1280x800";
      # highResolution = "1920x1080";
    } sharedOptions;
  };
}
