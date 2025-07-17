{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.solarsystem.modules.packages = lib.mkEnableOption "packages settings";
  config = lib.mkIf config.solarsystem.modules.packages {
    home.packages = with pkgs; [

    ];
  };
}
