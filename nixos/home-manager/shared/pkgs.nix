{ pkgs, stable, ... }: {

  # Specify the desired packages to install in the user environment.
  home.packages = with pkgs; [

    #Flutter
    # flutter

    #Utils
    texlivePackages.ifsym
    texliveFull
    latexrun
    pkg-config
    gtk3
    glib
    gtk4

    clippy
    rustc
    ra-multiplex
    rust-analyzer
    cargo
    #vim
    compose2nix
    maven
    valgrind
    ripgrep
    curl
    zoxide
    bat
    ouch
    zoxide
    docker-compose
    glade
    devenv
    gnumake
    cmake

    #Basic Language Development
    openjdk

    #Fonts
    liberation_ttf

    noto-fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove

    #Programs
    # logisim
    localsend
  ];
}
