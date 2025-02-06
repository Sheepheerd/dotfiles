{ pkgs, ... }: {

  # Specify the desired packages to install in the user environment.
  home.packages = with pkgs; [
    #vim
    maven
    ripgrep
    rustfmt
    git
    cargo
    curl
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    noto-fonts
    zoxide
    vesktop
    openjdk
  ];
}
