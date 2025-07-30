{
  programs.nixvim = {
    plugins = {
      colorful-menu.enable = true;
      blink-ripgrep.enable = true;
      blink-cmp-copilot.enable = true;
      blink-cmp = {
        enable = true;
        setupLspCapabilities = true;
        settings = {
          sources = {
            copilot = {
              async = true;
              module = "blink-cmp-copilot";
              name = "copilot";
              score_offset = 100;
            };
            providers = {
              lsp = {
                score_offset = 10;
              };
              buffer = {
                score_offset = 4;
              };
              path = {
                score_offset = 3;
              };
              ripgrep = {
                async = true;
                module = "blink-ripgrep";
                name = "Ripgrep";
                score_offset = 3;
                opts = {
                  prefix_min_len = 3;
                  context_size = 5;
                  max_filesize = "1M";
                  project_root_marker = ".git";
                  project_root_fallback = true;
                  search_casing = "--ignore-case";
                  additional_rg_options = { };
                  fallback_to_regex_highlighting = true;
                  ignore_paths = { };
                  additional_paths = { };
                  debug = false;
                };

              };
            };

          };
          completion = {
            accept = {
              auto_brackets.enabled = true;
            };
            ghost_text = {
              enabled = true;
            };
            documentation = {
              auto_show = false;
              auto_show_delay_ms = 200;
              window = {
                border = "rounded";
              };
            };
            menu = {
              draw = {
                treesitter = [ "lsp" ];
              };
              border = "rounded";
              # auto_show = true;
            };
          };
          snippets = {
            preset = "luasnip";
          };
          signature = {
            enabled = true;
            window = {
              border = "rounded";
              show_documentation = false;
            };
          };
          keymap = {
            preset = "default";
            "<TAB>" = [ "fallback" ];
          };
          appearance = {
            nerd_font_variant = "mono";
            use_nvim_cmp_as_default = true;
          };

        };
      };
    };
  };
}
