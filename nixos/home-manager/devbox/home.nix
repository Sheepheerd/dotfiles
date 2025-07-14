{ inputs, pkgs, ... }:
{

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ../shared
  ];

  fonts.fontconfig.enable = true;

  programs = {

    home-manager.enable = true;
    git.enable = true;

    # Neovim
    nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      luaLoader.enable = true;

      extraLuaPackages = ps: [ ps.magick ];
      extraPackages = [ pkgs.imagemagick ];
    };
  };

}
