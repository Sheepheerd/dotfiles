{ pkgs, inputs, ... }: {

  # Specify the desired packages to install in the user environment.
  home.packages = with pkgs; [

    #Utils
    distrobox
    nurl
    texlivePackages.ifsym
    texliveFull
    latexrun

    inputs.northstar.packages.${system}.default
    croc
    clippy
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
