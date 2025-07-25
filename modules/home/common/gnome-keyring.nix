{ lib, config, ... }:
{
  options.solarsystem.modules.gnome-keyring = lib.mkEnableOption "gnome keyring settings";
  config = lib.mkIf config.solarsystem.modules.gnome-keyring {
    services.gnome-keyring = lib.mkIf (!config.solarsystem.isNixos) {
      enable = true;
    };
  };
}
