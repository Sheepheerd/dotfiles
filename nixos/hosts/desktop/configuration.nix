{ config, lib, pkgs, inputs, outputs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.spicetify-nix.nixosModules.default
    ../../modules/desktop/default.nix
  ];

  environment.systemPackages = with pkgs;
    [ inputs.home-manager.packages.${pkgs.system}.default ];
  #environment.sessionVariables = { WLR_DRM_DEVICES = "/dev/dri/card0"; };
  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.libinput = { enable = true; };

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball
      "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;

      };
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11"; # Did you read the comment?

}

