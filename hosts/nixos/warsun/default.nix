{
  lib,
  ...
}:
let
  mainUser = "sheep";
  sharedOptions = {
    inherit mainUser;
    isLaptop = false;
    isNixos = true;
    isLinux = true;
    isDedicatedGaming = true;
    profiles = {
      gaming = true;
    };
  };
in
{

  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "warsun";
    interfaces.eno1.wakeOnLan.enable = true;
  };

  solarsystem = lib.recursiveUpdate {
    hasBluetooth = true;
    # FIX
    profiles = {
      # btrfs = true;
    };
  } sharedOptions;

  home-manager.users."${mainUser}" = {
    home.stateVersion = lib.mkForce "25.11";
    solarsystem = lib.recursiveUpdate {
      profiles = {
        nixvim = true;
      };
    } sharedOptions;
  };
}
