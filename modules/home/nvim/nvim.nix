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

      extraPlugins = [ pkgs.vimPlugins.kanso-nvim ];
      extraConfigLua = ''

        require('kanso').setup({
          transparent = true,
        })

        vim.cmd('colorscheme kanso')'';
    };
  };

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
}
