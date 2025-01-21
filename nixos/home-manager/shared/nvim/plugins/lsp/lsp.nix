{ config, ... }: {
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;
        inlayHints = true;
        capabilities = ''
          --require('blink.cmp').get_lsp_capabilities()
        '';
        keymaps = {
          silent = true;
          diagnostic = {
            # Navigate in diagnostics
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
          };

          lspBuf = {
            # gd = "definition";
            gD = "references";
            # gt = "type_definition";
            # gi = "implementation";
            # K = "hover";
            # "<F2>" = "rename";
          };
        };

        servers = {
          clangd = {
            enable = true;
            # cmd = [ "clangd" "--offset-encoding=utf-16" ];
          };
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
          nixd.enable = true;
          pyright.enable = true;
          pylsp.enable = true;
          tflint.enable = true;
          templ.enable = true;
          html.enable = true;
          htmx.enable = true;
          tailwindcss.enable = true;
        };
      };
    };
  };
}
