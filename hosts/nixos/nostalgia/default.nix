{
  lib,
  ...
}:
let
  mainUser = "jude";
  sharedOptions = {
    inherit mainUser;
    isLaptop = false;
    isNixos = true;
    isLinux = true;
    isDedicatedGaming = false;
    profiles = {
    };
  };
in
{

  imports = [
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "nostalgia";
  };

  virtualisation.vmVariant = {
    boot.loader.grub.enable = false;
    fileSystems."/".device = lib.mkForce "/dev/vda";
  };

  solarsystem = lib.recursiveUpdate {
    hasBluetooth = true;
    modules.kodi = true;
    profiles = {
      minimal = true;
    };
  } sharedOptions;

  # home-manager.users."${mainUser}" = {
  #   home.stateVersion = lib.mkForce "25.11";
  #   solarsystem = lib.recursiveUpdate {
  #     profiles = {
  #       nixvim = false;
  #     };
  #   } sharedOptions;
  # };
}
