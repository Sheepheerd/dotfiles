{ config, pkgs, inputs, host, ... }: {
  imports = [ ./waybar.nix ./fuzzel.nix ./dunst.nix ./gtk.nix ]
    ++ (if host == "novastar" || host == "deathstar" then
      [ ./hyprland ]
    else
      [ ]);
}
