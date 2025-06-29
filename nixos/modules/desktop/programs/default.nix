{ pkgs, inputs, ... }: {
  imports = [
    # ./spicetify.nix
    ./appimage.nix
    ./waydroid.nix
    ./steam.nix
    ./rom.nix
    ./minecraft.nix
    ./hyprland.nix
  ];
}
