{ pkgs, inputs, ... }: {
  imports = [
    ./hyprland.nix
    ./spicetify.nix
    ./vim.nix
    ./appimage.nix
    ./waydroid.nix
    ./steam.nix
  ];
}
