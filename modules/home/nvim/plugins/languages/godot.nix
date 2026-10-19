{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  # This repo overrides `lib` with its own extended nixpkgs lib, so nixvim's
  # helpers are not on the module's `lib`; reach for them through the input.
  inherit (inputs.nixvim.lib.nixvim) toLuaObject;

  cfg = config.solarsystem.modules.nixvim.godot;

  godotdev-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "godotdev.nvim";
    version = inputs.godotdev-nvim.shortRev or "unstable";
    src = inputs.godotdev-nvim;
    meta = {
      description = "Godot 4 LSP, DAP and formatting support for Neovim";
      homepage = "https://github.com/Mathijs-Bakker/godotdev.nvim";
      license = lib.licenses.mit;
    };
  };

  # Everything handed to require("godotdev").setup(). Grammars come from
  # nixvim's treesitter module, so the plugin must not try to install its own.
  settings = {
    treesitter.auto_setup = false;
  }
  // lib.optionalAttrs (cfg.package != null) {
    godot_path = lib.getExe cfg.package;
  }
  // cfg.settings;
in
{
  options.solarsystem.modules.nixvim.godot = {
    enable = lib.mkEnableOption "godotdev.nvim (Godot 4 LSP, DAP and formatting)";

    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = null;
      defaultText = lib.literalExpression "null";
      example = lib.literalExpression "pkgs.godot";
      description = ''
        Godot editor used by the `:GodotRun*` commands and `:checkhealth godotdev`.
        When null the plugin falls back to whatever `godot` is on PATH, which
        avoids pulling the engine into every host that enables nixvim.
      '';
    };

    formatterPackage = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.gdscript-formatter;
      defaultText = lib.literalExpression "pkgs.gdscript-formatter";
      description = "Formatter used for `.gd` files on save. Set to null to manage it yourself.";
    };

    settings = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = { };
      example = lib.literalExpression ''
        {
          csharp = true;
          inline_hints.enabled = true;
          run.console.enabled = true;
        }
      '';
      description = ''
        Extra options passed to `require("godotdev").setup()`.
        See https://github.com/Mathijs-Bakker/godotdev.nvim#configuration
      '';
    };
  };

  config = lib.mkIf (config.solarsystem.modules.nixvim.enable && cfg.enable) {
    programs.nixvim = {
      extraPlugins = [ godotdev-nvim ];

      extraPackages =
        lib.optional (cfg.formatterPackage != null) cfg.formatterPackage
        ++ lib.optional (cfg.package != null) cfg.package
        ++ [ pkgs.curl ];

      # Hard dependencies of the plugin: debugging and its UI.
      plugins = {
        dap.enable = true;
        dap-ui.enable = true;
        # gdscript/gdshader/godot_resource ship in nixvim's default grammar set.
        treesitter.enable = true;
      };

      extraConfigLua = ''
        require("godotdev").setup(${toLuaObject settings})
      '';
    };
  };
}
