{ config, ... }: {
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;
        inlayHints = true;
        capabilities = ''
          require('blink.cmp').get_lsp_capabilities()
        '';
        # capabilities = ''
        #   require('cmp_nvim_lsp').default_capabilities()
        #
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
            gD = "references";
            # gt = "type_definition";
            # gi = "implementation";
            # K = "hover";
            # "<F2>" = "rename";
          };
        };

        servers = {
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
          nixd.enable = true;

          basedpyright.enable = true;
          #pylsp.enable = true;
          tflint.enable = true;
          templ.enable = true;
          html.enable = true;
          # rust_analyzer = {
          #   enable = true;
          #   installCargo = true;
          # };
          # htmx.enable = true;
          # tailwindcss.enable = true;
        };
      };
    };
  };
}
