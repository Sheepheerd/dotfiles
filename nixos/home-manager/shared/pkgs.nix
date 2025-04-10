{ pkgs, ... }: {

  # Specify the desired packages to install in the user environment.
  home.packages = with pkgs; [
    #Utils
    pdflatex
    latexmk
    miktex
    pkg-config
    gtk3
    glib
    gtk4

    clippy
    rustc
    ra-multiplex
    rust-analyzer
    cargo
    alacritty
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
    python3

    #Basic Language Development
    openjdk

    #Fonts
    liberation_ttf

    noto-fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove

    #Programs
    youtube-music
    vesktop
    # ungoogled-chromium
    #firefox
    # logisim
    localsend
  ];
}
