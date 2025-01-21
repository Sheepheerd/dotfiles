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
          appearance = {
            kind_icons = {
              Copilot = "";
              Text = "󰉿";
              Method = "󰊕";
              Function = "󰊕";
              Constructor = "󰒓";

              Field = "󰜢";
              Variable = "󰆦";
              Property = "󰖷";

              Class = "󱡠";
              Interface = "󱡠";
              Struct = "󱡠";
              Module = "󰅩";

              Unit = "󰪚";
              Value = "󰦨";
              Enum = "󰦨";
              EnumMember = "󰦨";

              Keyword = "󰻾";
              Constant = "󰏿";

              Snippet = "󱄽";
              Color = "󰏘";
              File = "󰈔";
              Reference = "󰬲";
              Folder = "󰉋";
              Event = "󱐋";
              Operator = "󰪚";
              TypeParameter = "󰬛";
            };
          };

        };
      };
    };
  };
}
