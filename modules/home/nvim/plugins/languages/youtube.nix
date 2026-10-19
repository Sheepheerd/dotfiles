{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.solarsystem.modules.nixvim.youtube;

  # Vale with the selected styles baked in; the wrapper exports
  # VALE_STYLES_PATH, so the config below must not set StylesPath.
  vale = pkgs.vale.withStyles (styles: map (name: styles.${name}) cfg.vale.styles);

  valeConfig = pkgs.writeText "vale.ini" ''
    MinAlertLevel = ${cfg.vale.minAlertLevel}

    [*.md]
    BasedOnStyles = ${lib.concatStringsSep ", " ([ "Vale" ] ++ cfg.vale.styleNames)}
  '';
in
{
  options.solarsystem.modules.nixvim.youtube = {
    enable = lib.mkEnableOption "script writing setup for markdown (goyo, vale, spellcheck)";

    autoGoyo = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enter Goyo automatically when a markdown buffer is opened.";
    };

    spelllang = lib.mkOption {
      type = lib.types.str;
      default = "en_us";
      description = "Value for `spelllang` in markdown buffers.";
    };

    vale = {
      styles = lib.mkOption {
        type = with lib.types; listOf str;
        default = [
          "proselint"
          "write-good"
          "readability"
        ];
        description = "Attribute names from `pkgs.valeStyles` to install.";
      };

      styleNames = lib.mkOption {
        type = with lib.types; listOf str;
        default = [
          "proselint"
          "write-good"
          "Readability"
        ];
        description = ''
          Style names enabled in `BasedOnStyles` (the directory names inside the
          style packages, which do not always match the attribute names).
        '';
      };

      minAlertLevel = lib.mkOption {
        type = lib.types.enum [
          "suggestion"
          "warning"
          "error"
        ];
        default = "suggestion";
        description = "Lowest Vale alert level that is reported.";
      };
    };
  };

  config = lib.mkIf (config.solarsystem.modules.nixvim.enable && cfg.enable) {
    programs.nixvim = {
      plugins.goyo = {
        enable = true;
        settings = {
          width = 90;
          linenr = 0;
        };
      };

      extraPackages = [ vale ];

      lsp.servers.vale_ls = {
        enable = true;
        config = {
          filetypes = [ "markdown" ];
          # vale-ls shells out to vale, which inherits this environment.
          cmd_env = {
            VALE_CONFIG_PATH = "${valeConfig}";
            # Vale 3.17 segfaults intermittently on recent kernels with Go's
            # signal-based async preemption; disabling it makes it stable.
            GODEBUG = "asyncpreemptoff=1";
          };
        };
      };

      autoCmd = [
        {
          event = "FileType";
          pattern = [ "markdown" ];
          command = "setlocal spell spelllang=${cfg.spelllang} wrap linebreak";
        }
      ]
      ++ lib.optional cfg.autoGoyo {
        event = "FileType";
        pattern = [ "markdown" ];
        # Deferred so Goyo runs after the window layout is ready on startup.
        callback.__raw = ''
          function()
            vim.schedule(function()
              if vim.fn.exists("#goyo") == 0 then
                vim.cmd("Goyo")
              end
            end)
          end
        '';
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>z";
          action = "<cmd>Goyo<cr>";
          options = {
            silent = true;
            desc = "Toggle Goyo";
          };
        }
      ];
    };
  };
}
