{
  config,
  lib,
  inputs,
  ...
}:

with lib;

let
  cfg = config.solarsystem.modules.ageHome;
in
{
  options.solarsystem.modules.ageHome = mkEnableOption "Enable age secrets and include agenix";

  imports = [
    inputs.agenix.homeManagerModules.default
  ];
  config = mkIf cfg.enable {

    # age.secrets."firefly.core.env" = {
    #   file = ./env/firefly.core.age;
    #   owner = "sheep";
    #   group = "users";
    # };
    # age.secrets."firefly.db.env" = {
    #   file = ./env/firefly.db.age;
    #   owner = "sheep";
    #   group = "users";
    # };

    # Example for additional secrets:
    # age.secrets."firefly.core.env" = {
    #   file = inputs.self + /secrets/env/firefly.core.age;
    #   owner = "sheep";
    #   group = "users";
    # };
  };
}
