{
  lib,
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
    defaultGateway = "192.168.0.1";
    nameservers = [
      "127.0.0.1#5353"
    ];
    interfaces.enp4s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.0.10";
          prefixLength = 24;
        }
      ];
    };
  };

  solarsystem = lib.recursiveUpdate {
    modules.firewall = lib.mkForce true;
    hasBluetooth = false;

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
