{
  programs.nixvim = {
    plugins = {
      clangd-extensions = { enable = true; };
      lsp = {
        enable = true;
        inlayHints = true;
        capabilities = ''
          offsetEncoding = {'utf-16' , 'utf-8'};
        '';
        keymaps = {
          silent = true;
          diagnostic = {
            # Navigate in diagnostics
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
          };

          lspBuf = {
            gd = "definition";
            gD = "references";
            gt = "type_definition";
            gi = "implementation";
            K = "hover";
            "<F2>" = "rename";
          };
        };

        servers = {
          clangd = {
            enable = true;
            cmd = [ "clangd" "--offset-encoding=utf-16" ];
          };
          gopls.enable = true;
          golangci_lint_ls.enable = true;
          lua_ls.enable = true;
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
