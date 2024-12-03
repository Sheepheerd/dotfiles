{ pkgs, inputs, ... }: {
  imports = [
    ./hyprland.nix
    #  ./spicetify.nix
    ./zsh.nix
    ./vim.nix
    ./appimage.nix
    #  ./waydroid.nix
    #    ./yt_music.nix
    #./steam.nix
  ];
}
