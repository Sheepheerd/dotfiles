{ lib, config, ... }:
{
  options.solarsystem.profiles.minimal = lib.mkEnableOption "declare this a minimal host";
  config = lib.mkIf config.solarsystem.profiles.minimal {
    solarsystem = {

      fonts.enable = lib.mkDefault true;
      modules = {
        bootloader = lib.mkDefault true;
        packages = lib.mkDefault true;
        general = lib.mkDefault true;
        firewall = lib.mkDefault true;
        users = lib.mkDefault true;
        hardware = lib.mkDefault true;
        pipewire = lib.mkDefault true;
        udev = lib.mkDefault true;
        network = lib.mkDefault true;
        time = lib.mkDefault true;
        zsh = lib.mkDefault true;
        blueman = lib.mkDefault true;
        tailscale = lib.mkDefault true;
      };

    };
  };
}
