{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.solarsystem.modules.packages = lib.mkEnableOption "packages settings";

  config = lib.mkIf config.solarsystem.modules.packages {

    home.packages =
      with pkgs;
      let
        basePackages = [
          nurl
          curl
          wakeonlan
          unzip
          tree
          nettools
          pulsemixer
          lua
        ];

        extraNixosPackages = lib.optionals config.solarsystem.isNixos [
          vesktop
          youtube-music

        ];
      in
      basePackages ++ extraNixosPackages;
  };
}
