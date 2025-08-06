{
  lib,
  pkgs,
  config,
  ...
}:
let
  mullvad-autostart = pkgs.makeAutostartItem {
    name = "mullvad-vpn";
    package = pkgs.mullvad-vpn;
  };
in
{
  options.solarsystem.modules.mullvad = lib.mkEnableOption "Enable Mullvad VPN config";

  config = lib.mkIf config.solarsystem.modules.mullvad {
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    environment.systemPackages = [ mullvad-autostart ];
    # systemd = {
    #   services."mullvad-daemon".environment.MULLVAD_SETTINGS_DIR = "/var/lib/mullvad-vpn";
    #   tmpfiles.settings."10-mullvad-settings"."/var/lib/mullvad-vpn/settings.json"."C+" = {
    #     group = "root";
    #     mode = "0700";
    #     user = "root";
    #   };
    # };
  };
}
