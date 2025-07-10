{ pkgs, inputs, ... }: {
  imports = [
    # ./spicetify.nix
    ./orca-slicer.nix
    ./appimage.nix
    ./waydroid.nix
    ./steam.nix
    ./rom.nix
    ./minecraft.nix
    ./hyprland.nix
  ];
}
