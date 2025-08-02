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

      colorschemes.rose-pine = {
        enable = true;
        settings = {
          # extend_background_behind_borders = true;
          highlight_groups = {
            TelescopeBorder = {
              fg = "highlight_high";
              bg = "none";
            };
            TelescopeNormal = {
              bg = "none";
            };
            TelescopePromptNormal = {
              bg = "base";
            };
            TelescopeResultsNormal = {
              fg = "subtle";
              bg = "none";
            };
            TelescopeSelection = {
              fg = "text";
              bg = "base";
            };
            TelescopeSelectionCaret = {
              fg = "rose";
              bg = "rose";
            };
          };

          styles = {
            bold = true;
            italic = true;
            transparency = true;
          };

        };
      };
    };
  };

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
}
