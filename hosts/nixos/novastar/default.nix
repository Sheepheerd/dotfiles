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

  nix = {
    distributedBuilds = true;

    buildMachines = [
      {
        hostName = "solis";

        systems = [ "x86_64-linux" ];

        protocol = "ssh-ng";
        maxJobs = 16;
        speedFactor = 2;
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
        ];
      }
    ];
  };

  solarsystem = lib.recursiveUpdate {
    hasBluetooth = true;
    asahi = true;
    modules.virt = true;
    modules.box = true;
    modules.minecraft = true;
    x86 = true;
    muvm = true;

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
