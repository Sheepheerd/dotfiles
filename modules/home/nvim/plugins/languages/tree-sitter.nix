{ ... }:
{
  programs.nixvim = {
    plugins = {
      ts-autotag = {
        enable = true;
      };
      treesitter = {
        enable = true;
        settings = {
          highlight = {
            enable = true;
          };
          indent = {
            enable = true;
          };
          autopairs = {
            enable = true;
          };

          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = "<C-space>";
              node_incremental = "<C-space>";
              scope_incremental = false;
              node_decremental = "<bs>";
            };
          };
        };
        nixvimInjections = true;
      };

      treesitter-context = {
        enable = false;
      };

    };
  };
}
