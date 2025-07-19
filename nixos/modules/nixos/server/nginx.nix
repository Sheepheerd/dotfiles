{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.solarsystem.modules.server.nginx = lib.mkEnableOption "enable nginx on server";

  config = lib.mkIf config.solarsystem.modules.server.nginx {

    environment.systemPackages = with pkgs; [ ];

    security.acme = {
      acceptTerms = false;
      preliminarySelfsigned = false;
      defaults = { };
    };

    services.nginx = {
      enable = true;
      statusPage = true;
      recommendedProxySettings = true;
      # No TLS — Tailscale handles encryption
      recommendedTlsSettings = false;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;

      # Define virtualHosts in the module that depends on this
    };
  };
}
