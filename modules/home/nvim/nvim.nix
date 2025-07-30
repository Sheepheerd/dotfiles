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
          before_highlight = "function(group, highlight, palette) end";
          dark_variant = "moon";
          dim_inactive_windows = true;
          enable = {
            legacy_highlights = false;
            migrations = true;
            terminal = false;
          };
          extend_background_behind_borders = true;
          groups = {
            border = "muted";
            link = "iris";
            panel = "muted";
          };
          highlight_groups = { };
          styles = {
            bold = true;
            italic = true;
            transparency = true;
          };
          variant = "auto";

        };
      };
    };
  };

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
}
