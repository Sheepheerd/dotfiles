{ pkgs, inputs, ... }: {
  imports = [ ./hyprland.nix ./vim.nix ./appimage.nix ];
}
