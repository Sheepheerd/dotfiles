{ pkgs, outputs, lib, config, ... }:
let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    ref = "main";
  });
in {
  imports = [
    nixvim.homeManagerModules.nixvim
    ./desktop.nix
    ./gtk.nix
    ./tmux.nix
    ../shared/default.nix
  ];
  # Define the state version, which corresponds to the version of Home Manager
  # you are using. This should be updated whenever you update Home Manager.

  # Set up some basic settings for the home environment.
  home.username = "sheep";
  home.homeDirectory = "/home/sheep";

  # Define the Home Manager environment variables.
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "alacritty";
    LANG = "en_US.UTF-8";
  };

  # Enable custom fonts
  fonts.fontconfig.enable = true;

  programs = {
    # Enable Home Manager to manage your home directory.
    home-manager.enable = true;

    # direnv
    direnv.enable = true;

    ghostty = {
      enable = false;
      enableZshIntegration = true;
      settings = {
        theme = "catppuccin-mocha";
        font-size = 10;
      };
    };

    # Neovim
    nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      luaLoader.enable = true;
    };

  };
}
