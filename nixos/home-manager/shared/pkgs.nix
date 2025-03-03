{ pkgs, ... }: {

  # Specify the desired packages to install in the user environment.
  home.packages = with pkgs; [

    #Utils
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

    #Basic Language Development
    openjdk

    #Fonts
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
