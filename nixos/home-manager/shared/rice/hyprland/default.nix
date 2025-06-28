{ inputs, ... }: {
  imports = [
    ./hyprland.nix
    ./config.nix
    ./variables.nix
    ./hypridle.nix
    ./hyprlock.nix
    # inputs.hyprland.homeManagerModules.default
  ];
}
