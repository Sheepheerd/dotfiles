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
          # Utils
          nurl
          croc
          clippy
          curl
          wakeonlan

          # Oxidization
          ouch
          presenterm
          wiki-tui
          mask

          # uutils-coreutils-noprefix

          # Fonts
          liberation_ttf
          noto-fonts
          nerd-fonts.jetbrains-mono
          nerd-fonts.caskaydia-cove

          # Tools
          tree
          nettools
          pulsemixer
        ];

        extraNixosPackages = lib.optionals config.solarsystem.isNixos [
          vesktop
          youtube-music

        ];

      in
      # basePackages ++ extraNixosPackages ++ extraX86Packages;
      basePackages ++ extraNixosPackages;
  };
}
