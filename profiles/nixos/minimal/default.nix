{ lib, config, ... }:
{
  options.solarsystem.profiles.minimal = lib.mkEnableOption "declare this a minimal host";
  config = lib.mkIf config.solarsystem.profiles.minimal {
    solarsystem.modules = {
      bootloader = lib.mkDefault true;
      # general = lib.mkDefault true;
      # home-manager = lib.mkDefault true;
      # time = lib.mkDefault true;
      # users = lib.mkDefault true;
      # zsh = lib.mkDefault true;

      # server = {
      #   ssh = lib.mkDefault true;
      # };
    };

  };

}
