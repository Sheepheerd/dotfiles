{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.solarsystem.modules.packages = lib.mkEnableOption "packages settings";

  config = lib.mkIf config.solarsystem.modules.packages {

    programs = {
      nix-your-shell = {
        enable = true;
        enableZshIntegration = true;
      };

      ripgrep.enable = true;
      zoxide.enable = true;
      bat.enable = true;
    };

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

          # Python
          pyenv

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
