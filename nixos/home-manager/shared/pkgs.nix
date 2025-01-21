{ pkgs, ... }: {

  # Specify the desired packages to install in the user environment.
  home.packages = with pkgs; [
    #vim
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
  ];
}
