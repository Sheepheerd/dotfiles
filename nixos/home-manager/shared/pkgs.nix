{ pkgs, ... }: {

  # Specify the desired packages to install in the user environment.
  home.packages = with pkgs; [
    #Utils
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

    #Basic Language Development
    openjdk

    #Fonts
    noto-fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove

    #Programs
    vesktop
    firefox
    # logisim
    localsend
  ];
}
