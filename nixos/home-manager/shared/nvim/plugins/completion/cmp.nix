{
  programs.nixvim = {
    opts.completeopt = [ "menu" "menuone" "noselect" ];
    plugins = {
      cmp-nvim-lsp-signature-help.enable = true;
      # cmp-cmdline = { enable = true; }; # autocomplete for cmdline
      # cmp_luasnip = { enable = true; }; # snippets
      copilot-cmp = { enable = true; }; # copilot suggestions
      cmp-treesitter = { enable = true; };
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          experimental = { ghost_text = true; };
          mapping = {
            "<Tab>" = "";

            "<S-Tab>" = "";

            "<C-j>" = "cmp.mapping.select_next_item()";
            "<C-k>" = "cmp.mapping.select_prev_item()";

            "<C-n>" = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                else
                  fallback()
                end
              end, { "i", "s" })
            '';

            "<C-p>" = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" })
            '';

            "<C-e>" = "cmp.mapping.abort()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-y>" =
              "cmp.mapping.confirm({ select = false })"; # Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            "<S-CR>" =
              "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "copilot"; }
            {
              name = "buffer";
              keyword_length = 5;
            }
            {
              name = "path";
              keyword_length = 3;
            }
            {
              name = "luasnip";
              keyword_length = 3;
            }
            { name = "treesitter"; }
            { name = "nvim_lsp_signature_help"; }
          ];

          # Enable pictogram icons for lsp/autocompletion
          formatting = {
            fields = [ "kind" "abbr" "menu" ];
            expandable_indicator = true;
          };
          performance = {
            debounce = 60;
            fetching_timeout = 200;
            max_view_entries = 20;
          };
          view.docs.auto_open = false;
          window = {
            completion = {
              border = "rounded";
              winhighlight =
                "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
            };
            documentation = { border = "rounded"; };
          };
        };
      };
    };

    extraConfigLua = ''
      luasnip = require("luasnip")
      kind_icons = {
        Text = "󰊄",
        Method = "",
        Function = "󰡱",
        Constructor = "",
        Field = "",
        Variable = "󱀍",
        Class = "",
        Interface = "",
        Module = "󰕳",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
      }

      local cmp = require'cmp'

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({'/', "?" }, {
        sources = {
          { name = 'buffer' }
        }
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
        { name = 'buffer' },
        })
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
        { name = 'cmdline' }
        }),
      })
    '';
  };
}
