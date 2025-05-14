{ pkgs, ... }:
let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    ref = "main";
  });
in {

  imports = [ nixvim.homeManagerModules.nixvim ../shared/default.nix ];

  nixpkgs = { config = { allowUnfree = false; }; };

  home = {
    username = "sheep";
    homeDirectory = "/home/sheep";
  };

  # programs.neovim.enable = true;
  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;
  programs.git.enable = true;

  systemd.user.startServices = "sd-switch";
  # Neovim
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;
  };

}
