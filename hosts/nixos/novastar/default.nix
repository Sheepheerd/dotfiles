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

    settings = {
      extra-substituters = [
        "https://nixos-apple-silicon.cachix.org"
        #  "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
        #  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    distributedBuilds = true;

    buildMachines = [
      {
        hostName = "solis";
        # nix-daemon connects as root, which has no key of its own
        sshUser = "sheep";
        sshKey = "/home/sheep/.ssh/id_rsa";

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

  programs.ssh.knownHosts.solis.publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/nhkvST55B5vzLLiHK3kof50GTUjskIp/bmw5+vZGU";

  solarsystem = lib.recursiveUpdate {
    hasBluetooth = true;
    asahi = true;
    modules.virt = false;
    modules.box = false;
    # modules.minecraft = true;
    modules.youtube = true;

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
