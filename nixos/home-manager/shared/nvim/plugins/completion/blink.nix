{
  programs.nixvim = {
    plugins = {
      blink-ripgrep.enable = true;
      # blink-cmp-copilot.enable = true;
      blink-cmp = {
        enable = true;
        settings = {

          sources.default =
            # [ "lsp" "path" "snippets" "buffer" "copilot" "ripgrep" ];
            [ "lsp" "path" "snippets" "buffer" "ripgrep" ];
          sources.providers = {
            # copilot = {
            #   async = true;
            #   module = "blink-cmp-copilot";
            #   name = "copilot";
            #   score_offset = 100;
            # };
            ripgrep = {
              async = true;
              module = "blink-ripgrep";
              name = "Ripgrep";
              score_offset = 100;
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
          completion = {
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
              window = { border = "rounded"; };
            };
            menu = { border = "rounded"; };
          };
          snippets = { preset = "luasnip"; };
          signature = { enabled = true; };
          appearance = {
            nerd_font_variant = "mono";
            # kind_icons = {
            #   Copilot = "";
            #   Text = "󰉿";
            #   Method = "󰊕";
            #   Function = "󰊕";
            #   Constructor = "󰒓";
            #
            #   Field = "󰜢";
            #   Variable = "󰆦";
            #   Property = "󰖷";
            #
            #   Class = "󱡠";
            #   Interface = "󱡠";
            #   Struct = "󱡠";
            #   Module = "󰅩";
            #
            #   Unit = "󰪚";
            #   Value = "󰦨";
            #   Enum = "󰦨";
            #   EnumMember = "󰦨";
            #
            #   Keyword = "󰻾";
            #   Constant = "󰏿";
            #
            #   Snippet = "󱄽";
            #   Color = "󰏘";
            #   File = "󰈔";
            #   Reference = "󰬲";
            #   Folder = "󰉋";
            #   Event = "󱐋";
            #   Operator = "󰪚";
            #   TypeParameter = "󰬛";
            # };
            use_nvim_cmp_as_default = false;
          };

        };
      };
    };
  };
}
