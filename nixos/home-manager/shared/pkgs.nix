{ pkgs, lib, host, ... }:
let

  isNovastar = host == "novastar";
  isDeathstar = host == "deathstar";
  isHomeMachine = isNovastar || isDeathstar;
in {

  # Specify the desired packages to install in the user environment.

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    nix-your-shell = {
      enable = true;
      enableZshIntegration = true;
    };

    ripgrep.enable = true;

    eza.enable = true;

    zoxide.enable = true;

    bat.enable = true;

    yazi.enable = true;
  };

  home.packages = with pkgs;
    [

      #Utils
      typst
      distrobox
      nurl
      croc
      clippy
      maven
      valgrind
      curl

      #Oxidization
      ouch # Decompressing at its finest
      presenterm # power point in terminal
      wiki-tui # Wiki in the terminal
      mask # Command Runner like make. Will run 'sh' markdown patterns in readme

      gnumake
      cmake
      uutils-coreutils-noprefix
      docker-compose

      #Fonts
      liberation_ttf

      noto-fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-cove

      #python
      pyenv

    ] ++ lib.optionals isDeathstar [

      compose2nix
      localsend
      # texlivePackages.ifsym
      # texliveFull
      # latexrun
      ra-multiplex
      vial
      qmk
      hunspell
      hunspellDicts.uk_UA
      hunspellDicts.th_TH
      joplin-desktop
      gimp
      orca-slicer
      #blender
      rpi-imager

    ]

    ++ lib.optionals isHomeMachine [ vesktop youtube-music grimblast ];
}
