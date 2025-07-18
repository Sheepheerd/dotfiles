{
  lib,
  config,
  ...
}:

{
  options.solarsystem.modules.screenControl =
    lib.mkEnableOption "Enable screen brightness control with 'light' and 'actkbd'"
    // {
      default = config.solarsystem.isLaptop;
    };

  config = lib.mkIf config.solarsystem.modules.screenControl {
    # Brightness control
    programs.light.enable = true;

    services.actkbd = {
      enable = true;
      bindings = [
        {
          keys = [ 225 ]; # Brightness up
          events = [ "key" ];
          command = "/run/current-system/sw/bin/light -A 5";
        }
        {
          keys = [ 224 ]; # Brightness down
          events = [ "key" ];
          command = "/run/current-system/sw/bin/light -U 5";
        }
      ];
    };
  };
}
