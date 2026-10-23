{
  lib,
  pkgs,
  inputs,
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

  environment.systemPackages = with pkgs; [
    inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  networking = {
    hostName = "solis";
    # no public IPv6 exposure; the tailnet works over its 100.64.0.0/10 addresses
    enableIPv6 = false;
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
