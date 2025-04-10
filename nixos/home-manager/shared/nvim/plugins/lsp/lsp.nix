{ config, ... }: {
  programs.nixvim = {
    plugins = {
      # lsp-signature.enable = true;
      # lsp-lines.enable = true;
      lsp = {
        enable = true;
        inlayHints = true;
        capabilities = ''
          require('blink.cmp').get_lsp_capabilities()
        '';
        # capabilities = ''
        #   require('cmp_nvim_lsp').default_capabilities()
        # '';
        # capabilities = ''
        #   require('coq').lsp_ensure_capabilities()
        # '';
        keymaps = {
          silent = true;
          diagnostic = {
            # Navigate in diagnostics
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
          };

          lspBuf = {
            # gd = "definition";
            # gD = "references";
            # gt = "type_definition";
            # gi = "implementation";
            # K = "hover";
            "<leader>cr" = "rename";
            "<leader>ca" = "code_action";
          };
        };

        servers = {
          texlab.enable = true;
          jsonls = { enable = true; };
          # cssls = { enable = true; };
          clangd = {
            enable = true;
            # cmd = [ "clangd" "--offset-encoding=utf-16" ];
          };
          dockerls = { enable = true; };
          docker_compose_language_service = { enable = true; };
          gopls.enable = true;
          golangci_lint_ls.enable = true;
          lua_ls = {
            enable = true;
            extraOptions = {
              settings = {
                workspace = { checkThirdParty = "false"; };
                Lua = {
                  diagnostics = { globals = [ "love" ]; };
                  telemetry = { enabled = false; };
                  hint = { enable = true; };
                };
              };
            };
          };
          nil_ls = {
            enable = true;
            settings.nix.flake.autoArchive = true;
          };
          basedpyright.enable = true;
          tflint.enable = true;
          templ.enable = true;
          html.enable = true;
          # rust_analyzer = {
          #   enable = true;
          #   installCargo = true;
          #   installRustc = true;
          # };
          # htmx.enable = true;
          # tailwindcss.enable = true;
        };
        luaConfig.post = ''
          vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResized' }, {
            desc = 'Setup LSP hover window',
            callback = function()
              local width = math.floor(vim.o.columns * 0.8)
              local height = math.floor(vim.o.lines * 0.3)

              vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = 'rounded',
                max_width = width,
                max_height = height,
              })
            end,
          })
        '';

      };
    };
  };
}
