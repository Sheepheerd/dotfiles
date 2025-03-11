{ pkgs, ... }: {

  # Specify the desired packages to install in the user environment.
  home.packages = with pkgs; [

    #Utils
    pkg-config
    gtk3
    glib
    gtk4

    pkg-config
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
    tailscale
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
    joplin
    vesktop
    # ungoogled-chromium
    #firefox
    # logisim
    localsend
  ];
}
