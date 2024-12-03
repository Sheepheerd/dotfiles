{ pkgs, inputs, ... }: {
  imports = [
    ./hyprland.nix
    ./spicetify.nix
    ./zsh.nix
    ./vim.nix
    ./appimage.nix
    ./waydroid.nix
    ./steam.nix
  ];
}
