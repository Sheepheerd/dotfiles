{ pkgs, inputs, apple-silicon, ... }:

{
  imports = [ # Include the results of the hardware scan.
    # ./apple-silicon-support
    ./hardware-configuration.nix
    ../../modules/laptop/default.nix
    inputs.apple-silicon.nixosModules.apple-silicon-support
  ];

  environment.systemPackages = with pkgs;
    [ inputs.home-manager.packages.${pkgs.system}.default ];
  programs.nix-ld.enable = true;
  nixpkgs.overlays = [ inputs.apple-silicon.overlays.apple-silicon-overlay ];
  hardware = {
    asahi = {
      enable = true;
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "replace";
      setupAsahiSound = true;
    };
  };

  boot.loader.efi.canTouchEfiVariables = false;
  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.libinput = { enable = true; };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11"; # Did you read the comment?

}
