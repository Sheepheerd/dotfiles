{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.spicetify-nix.nixosModules.default
	];

  # Enable touchpad support (enabled default in most desktopManager).
services.libinput.enable = true;
#services.xserver.synaptics.enable = true;


nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11"; # Did you read the comment?

}

