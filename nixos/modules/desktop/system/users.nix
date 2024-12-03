{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      rofi-calc = prev.rofi-calc.override {
        rofi-unwrapped = prev.rofi-wayland-unwrapped;
      };
    })
  ];

  users.users.sheep = {
    isNormalUser = true;
    description = "Mr. Big Steppa";
    extraGroups = [ "networkmanager" "input" "wheel" "video" "audio" "tss" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      unzip
      vim
      stow
      vesktop
      neovim
      firefox
      logisim
      libreoffice
      hunspell
      hunspellDicts.en_US
      xclip
      dmenu
      rofi-wayland
      tectonic
      grimblast
      grim
      kitty
      # easyeffects
      gvfs
    ];
  };

}
