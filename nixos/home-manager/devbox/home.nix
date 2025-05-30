{ inputs, pkgs, ... }: {

  imports = [ inputs.nixvim.homeManagerModules.nixvim ../shared/default.nix ];

  nixpkgs = { config = { allowUnfree = true; }; };

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Neovim
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;

    extraLuaPackages = ps: [ ps.magick ];
    extraPackages = [ pkgs.imagemagick ];
  };

}
