{ lib, config, ... }:
{

  # . /home/sheep/.nix-profile/etc/profile.d/nix.sh
  options.solarsystem.profiles.laptop = lib.mkEnableOption "is this a reduced personal host";
  config = lib.mkIf config.solarsystem.profiles.laptop {
    solarsystem.modules = {
      packages = lib.mkDefault true;
      general = lib.mkDefault true;
      desktop = lib.mkDefault true;
      direnv = lib.mkDefault true;
      eza = lib.mkDefault true;
      git = lib.mkDefault true;
      fuzzel = lib.mkDefault true;
      zsh = lib.mkDefault true;
      gnome-keyring = lib.mkDefault true;
      mako = lib.mkDefault true;
      ghostty = lib.mkDefault true;
      gtk = lib.mkDefault true;
      tmux = lib.mkDefault true;
      waybar.enable = lib.mkDefault true;
      hyprland = lib.mkDefault true;
      # nixvim = lib.mkDefault true;
    };
  };

}
