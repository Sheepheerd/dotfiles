{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      rofi-calc = prev.rofi-calc.override {
        rofi-unwrapped = prev.rofi-wayland-unwrapped;
      };
    })
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sheep = {
    isNormalUser = true;
    description = "Mr. Big Steppa";
    extraGroups =
      [ "networkmanager" "input" "wheel" "ydotool" "video" "audio" "tss" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      unzip
      vim
      stow
      xclip
      dmenu
      rofi-wayland
      # tectonic
      grimblast
      grim
      kitty
    ];
  };

}
