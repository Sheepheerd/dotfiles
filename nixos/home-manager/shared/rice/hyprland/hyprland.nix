{ pkgs, inputs, lib, host, ... }: {

  home.packages = with pkgs; [
    swww
    # inputs.hypr-contrib.packages.${pkgs.system}.grimblast
    # inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    grim
    slurp
    wl-clip-persist
    cliphist
    wf-recorder
    glib
    wayland
  ];

  programs = {
    hyprlock = { enable = true; };
    # hyprlidle = { enable = true; };
    # hyprpolkitagent.enable = true;
    # hyprsunset.enable = true;
  };

  wayland.windowManager.hyprland = {

    enable = true;

    xwayland = { enable = true; };

  };

  programs.kitty.enable = false; # required for the default Hyprland config

}
