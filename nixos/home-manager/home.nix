{ pkgs, outputs, lib, config, nixgl, inputs, ... }: {

  imports = [ inputs.nixvim.homeManagerModules.nixvim ../shared/default.nix ];

  home.username = "sheep";
  home.homeDirectory = "/home/sheep";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "alacritty";
    LANG = "en_US.UTF-8";
  };

  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;

    direnv.enable = true;

    nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      luaLoader.enable = true;
    };
  };

}
