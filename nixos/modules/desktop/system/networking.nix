{ pkgs, ... }:

{
  # Enable networking
  networking.hostName = "deathstar"; # Define your hostname.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.
  # networking.networkmanager.wifi.backend = "iwd";

  environment.systemPackages = with pkgs; [ ];
}
