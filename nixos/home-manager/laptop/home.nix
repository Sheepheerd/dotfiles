{ inputs, ... }:

{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ../shared/default.nix ];

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

  };

}
