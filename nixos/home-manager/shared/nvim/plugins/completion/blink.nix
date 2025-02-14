{
  programs.nixvim = {
    plugins = {
      blink-cmp-copilot.enable = true;
      blink-cmp = {
        enable = true;
        settings = {

          sources.default = [ "lsp" "path" "snippets" "buffer" "copilot" ];
          sources.providers = {
            copilot = {
              async = true;
              module = "blink-cmp-copilot";
              name = "copilot";
              score_offset = 100;
            };
          };
          completion = {
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
            };
            menu = { border = "rounded"; };
          };
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
