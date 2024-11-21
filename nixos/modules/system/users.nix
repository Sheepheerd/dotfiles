{ pkgs, inputs, ... }:

{
nixpkgs.overlays = [(final: prev: {
  rofi-calc = prev.rofi-calc.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
})];


#programs.spicetify =
#   let
#     spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
#   in
#   {
#     enable = true;
#     enabledExtensions = with spicePkgs.extensions; [
#       adblock
#       hidePodcasts
#       shuffle # shuffle+ (special characters are sanitized out of extension names)
#     ];
#     #theme = spicePkgs.themes.catppuccin;
#     #colorScheme = "mocha";
#   };

  # Define a user account. Don't forget to set a password with ‘passwd’.
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
];
    };

}
