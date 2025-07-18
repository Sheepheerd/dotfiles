{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.solarsystem.modules.nixvim;
in
{
  options.solarsystem.modules.nixvim = lib.mkEnableOption "Enable and configure NixVim with additional packages";

  config = lib.mkIf cfg {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      luaLoader.enable = true;

      extraLuaPackages = ps: [ ps.magick ];
      extraPackages = [ pkgs.imagemagick ];
    };
  };

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
}
