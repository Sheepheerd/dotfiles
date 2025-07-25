{ lib, config, ... }:

let
  cfg = config.solarsystem.modules;
in
{
  options.solarsystem.modules.gnome-keyring = lib.mkEnableOption "Enable gnome-keyring config";

  config = lib.mkIf cfg.gnome-keyring {
    services.gnome.gnome-keyring.enable = true;

    programs.seahorse.enable = true;
  };
}
