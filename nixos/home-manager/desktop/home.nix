{ inputs, outputs, lib, config, pkgs, pkgs-unstable, nixvim, ... }:
# You can import other home-manager modules here
# let
#   nixvim = import (builtins.fetchGit {
#     url = "https://github.com/nix-community/nixvim";
#     ref = "main";
#   });
# in
{

  imports = [
    # nixvim.homeManagerModules.nixvim
    ./desktop.nix
    ./gtk.nix
    ./easyeffects.nix
    ../shared/default.nix
    ./desktop-pkgs.nix
    # ./minecraft.nix
  ];

  nixpkgs = {
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # programs.neovim.enable = true;
  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;
  programs.git.enable = true;

  systemd.user.startServices = "sd-switch";
  # Neovim
  # programs.nixvim = {
  #   enable = true;
  #   defaultEditor = true;
  #   viAlias = true;
  #   vimAlias = true;
  #
  #   luaLoader.enable = true;
  # };

}
