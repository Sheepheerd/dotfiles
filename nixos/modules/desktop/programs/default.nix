{ pkgs, inputs, ... }: {
  imports = [
    ./hyprland.nix
    # ./spicetify.nix
    ./appimage.nix
    ./waydroid.nix
    ./steam.nix
    ./rom.nix
    ./minecraft.nix
  ];
}
