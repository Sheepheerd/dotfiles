{ config, lib, pkgs, unstable, inputs, outputs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/desktop/default.nix
  ];

  environment.systemPackages = with pkgs;
    [ inputs.home-manager.packages.${pkgs.system}.default ];
  # environment.sessionVariables = { WLR_DRM_DEVICES = "/dev/dri/card0"; };
  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.libinput = { enable = true; };

  nixpkgs.config.packageOverrides = pkgs:
    {
      # nur = import (builtins.fetchTarball
      #   "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      #     inherit pkgs;
      #
      #   };
    };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05"; # Did you read the comment?

}
