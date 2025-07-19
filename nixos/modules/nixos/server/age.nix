{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;

let
  cfg = config.solarsystem.modules.ageServer;
in
{
  options.solarsystem.modules.ageServer = mkEnableOption "Enable age secrets and include agenix";

  config = mkIf cfg {

    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.system}.default
    ];

    age.secrets."immich.env" = {
      file = inputs.self + /secrets/server/immich.age;
      owner = "sheep";
      group = "users";
    };

  };
}
