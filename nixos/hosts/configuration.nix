{ config, lib, pkgs, inputs, outputs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #      inputs.spicetify-nix.nixosModules.default
    ../modules/default.nix
    ../apple-silicon-support
  ];

  hardware.asahi.peripheralFirmwareDirectory = ../firmware;
  environment.systemPackages = with pkgs; [
    mesa
    mesa.drivers
    inputs.home-manager.packages.${pkgs.system}.default
  ];
  hardware.asahi.useExperimentalGPUDriver = true;
  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = { enable = true; };
  #services.xserver.synaptics.enable = true;

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball
      "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;

      };
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11"; # Did you read the comment?

}

