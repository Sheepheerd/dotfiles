{
  lib,
  config,
  pkgs,
  ...
}:

{
  # Define the main LSP option
  options.solarsystem.modules.nixvim.lsp = {
    enable = lib.mkEnableOption "nixvim lsp";
    servers = {
      ghdl_ls = lib.mkEnableOption "ghdl_ls LSP server";
      arduino_language_server = lib.mkEnableOption "arduino_language_server LSP server";
      asm_lsp = lib.mkEnableOption "asm_lsp LSP server";
      tinymist = lib.mkEnableOption "tinymist LSP server";
      jdtls = lib.mkEnableOption "jdtls LSP server";
      ltex = lib.mkEnableOption "ltex LSP server";
      jsonls = lib.mkEnableOption "jsonls LSP server";
      clangd = lib.mkEnableOption "clangd LSP server";
      dockerls = lib.mkEnableOption "dockerls LSP server";
      docker_compose_language_service = lib.mkEnableOption "docker_compose_language_service LSP server";
      gopls = lib.mkEnableOption "gopls LSP server";
      golangci_lint_ls = lib.mkEnableOption "golangci_lint_ls LSP server";
      lua_ls = lib.mkEnableOption "lua_ls LSP server";
      hls = lib.mkEnableOption "hls LSP server";
      nixd = lib.mkEnableOption "nil_ls LSP server";
      basedpyright = lib.mkEnableOption "basedpyright LSP server";
      tflint = lib.mkEnableOption "tflint LSP server";
      templ = lib.mkEnableOption "templ LSP server";
      html = lib.mkEnableOption "html LSP server";
      rust = lib.mkEnableOption "rust_analyzer LSP server";
      elixir = lib.mkEnableOption "elixir LSP server";
      verilog = lib.mkEnableOption "verilog LSP server";
      bash = lib.mkEnableOption "bash LSP server";
    };
  };

  config = lib.mkIf config.solarsystem.modules.nixvim.lsp.enable {
    # GCC-only flags from the ESP-IDF compile_commands.json that clang rejects.
    # Lives in the user config so ESP projects need no .clangd of their own.
    home.file.${
      if pkgs.stdenv.isDarwin then
        "Library/Preferences/clangd/config.yaml"
      else
        ".config/clangd/config.yaml"
    } =
      lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.clangd {
        text = ''
          CompileFlags:
            Remove:
              - -mlongcalls
              - -mtext-section-literals
              - -mdisable-hardware-atomics
              - -mfix-esp32-psram-cache-issue
              - -mfix-esp32-psram-cache-strategy=*
              - -fstrict-volatile-bitfields
              - -fno-tree-switch-conversion
              - -fno-shrink-wrap
              - -fzero-init-padding-bits=*
              - -specs=*
              - -march=rv32*
              - -mabi=ilp32*
          Diagnostics:
            Suppress:
              - drv_unknown_argument
              - drv_unsupported_opt
        '';
      };

    programs.nixvim = {
      lsp = {
        keymaps = [
          {
            key = "gd";
            lspBufAction = "definition";
          }
          {
            key = "gD";
            lspBufAction = "references";
          }
          {
            key = "gt";
            lspBufAction = "type_definition";
          }
          {
            key = "gi";
            lspBufAction = "implementation";
          }
          {
            key = "K";
            lspBufAction = "hover";
          }
          {
            key = "<leader>ca";
            lspBufAction = "code_action";
          }
          # {
          #   action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_definitions";
          #   key = "gd";
          # }
        ];
        servers = {
          ghdl_ls = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.ghdl_ls {
            enable = true;
            package = null;
          };
          asm_lsp = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.asm_lsp {
            enable = true;

            config = {
              # cmd = [ "asm-lsp" ];
              # rootMarkers = [
              #   "asm-lsp.toml"
              #   ".git"
              # ];
              filetypes = [
                "asm"
                "nasm"
                "S"
              ];
            };
          };
          tinymist = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.tinymist {
            enable = true;
          };
          jdtls = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.jdtls {
            enable = false;
          };
          bashls = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.bash {
            enable = true;
          };
          ltex = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.ltex {
            enable = true;
          };
          jsonls = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.jsonls {
            enable = true;
          };
          clangd = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.clangd {
            # Resolved from PATH so a project devshell (e.g. esp-clang) wins;
            # pkgs.clang-tools is appended below as the fallback.
            package = null;
            enable = true;
            config.cmd = [
              "clangd"
              "--background-index"
              "--header-insertion=never"
              # Let clangd ask the cross compilers for their sysroot/newlib includes.
              "--query-driver=**/xtensa-esp*-elf-gcc,**/xtensa-esp*-elf-g++,**/riscv32-esp-elf-gcc,**/riscv32-esp-elf-g++,**/arm-none-eabi-gcc,**/arm-none-eabi-g++"
            ];
          };
          dockerls = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.dockerls {
            enable = true;
          };
          docker_compose_language_service =
            lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.docker_compose_language_service
              {
                enable = true;
              };
          gopls = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.gopls {
            enable = true;
          };
          golangci_lint_ls = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.golangci_lint_ls {
            enable = false;
          };
          hls = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.hls {
            enable = true;
            installGhc = false;
          };
          nixd = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.nixd {
            enable = true;
            config.nix.flake.autoArchive = true;
          };
          lua_ls = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.lua_ls {
            enable = true;
          };
          basedpyright = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.basedpyright {
            enable = true;
          };
          tflint = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.tflint {
            enable = true;
          };
          templ = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.templ {
            enable = true;
          };
          html = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.html {
            enable = true;
          };
          rust_analyzer = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.rust {
            enable = true;
          };
          verible = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.verilog {
            enable = true;
          };
          elixirls = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.elixir {
            enable = true;
            config = {
              cmd = [ "elixir-ls" ];
              root_markers = [
                ".git"
              ];
            };
          };
          arduino_language_server =
            lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.arduino_language_server
              {
                enable = true;
                # rootMarkers = [ ".git" ];
                config = {
                  capabilities = {
                    textDocument.semanticTokens = null;
                    workspace.semanticTokens = null;
                  };
                  cmd = [
                    "arduino-language-server"
                    "-clangd"
                    "clangd"
                    "-cli"
                    "arduino-cli"
                    "-cli-config"
                    "/home/sheep/.arduino15/arduino-cli.yaml"
                    "-fqbn"
                    "esp32:esp32:esp32"
                  ];
                };

              };
        };
      };

      extraPackagesAfter = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.clangd [
        pkgs.clang-tools
      ];

      plugins = {
        java = {
          enable = false;
          settings = {
            spring_boot_tools.enable = false;
            java_debug_adapter = {
              enable = true;
            };
          };
        };
        ltex-extra.enable = lib.mkIf config.solarsystem.modules.nixvim.lsp.servers.ltex true;
        # lsp = {
        #   luaConfig.post = ''
        #     vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResized' }, {
        #       desc = 'Setup LSP hover window',
        #       callback = function()
        #         local width = math.floor(vim.o.columns * 0.8)
        #         local height = math.floor(vim.o.lines * 0.3)
        #         vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        #           border = 'rounded',
        #           max_width = width,
        #           max_height = height,
        #         })
        #       end,
        #     })
        #   '';
        # };
      };
    };
  };
}
