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

    eza.enable = true;

    zoxide.enable = true;

    bat.enable = true;

  };
home.packages = with pkgs; [

      #Utils
      typst
      nurl
      croc
      clippy
      curl

      #Oxidization
      ouch # Decompressing at its finest
      presenterm # power point in terminal
      wiki-tui # Wiki in the terminal
      mask # Command Runner like make. Will run 'sh' markdown patterns in readme

      uutils-coreutils-noprefix

      #Fonts
      liberation_ttf

      noto-fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-cove

      #python
      pyenv

    ];
  };
}
