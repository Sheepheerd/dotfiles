{ pkgs, ... }: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      ruff
      google-java-format
      prettierd
      # clang-tools
      nixfmt
      astyle
      stylua
      typescript
      typescript-language-server
    ];
    plugins.conform-nvim = {
      enable = true;
      settings = {
        notify_on_error = false;
        # default_format_opts = {
        #   lsp_format = "fallback";
        # };
        # format_after_save = {
        #   lsp_format = "fallback";
        # };
        format_on_save = {
          timeoutMs = 500;
          lspFallback = true;
        };
        formatters_by_ft = {
          html = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          css = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          javascript = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          javascriptreact = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          typescript = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          typescriptreact = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          java = [ "google-java-format" ];
          python = [ "ruff" "black" ];
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          cpp = [ "astyle" ];
          markdown = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          rust = [ "rustfmt" ];
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>uf";
        action = ":FormatToggle<CR>";
        options = {
          desc = "Toggle Format Globally";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>uF";
        action = ":FormatToggle!<CR>";
        options = {
          desc = "Toggle Format Locally";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>cf";
        action = "<cmd>lua require('conform').format()<cr>";
        options = {
          silent = true;
          desc = "Format Buffer";
        };
      }

      {
        mode = "v";
        key = "<leader>cF";
        action = "<cmd>lua require('conform').format()<cr>";
        options = {
          silent = true;
          desc = "Format Lines";
        };
      }
    ];
  };
}
