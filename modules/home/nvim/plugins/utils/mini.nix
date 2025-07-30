{
  programs.nixvim.plugins.mini = {
    enable = true;
    mockDevIcons = true;
    modules = {
      ai = {
        n_lines = 50;
        search_method = "cover_or_next";
      };
      icons = {
        style = "ascii";
      };
      surround = {
        mappings = {
          add = "sa";
          delete = "sd";
          find = "sf";
          find_left = "sF";
          highlight = "sh";
          replace = "sr";
        };
      };
      clue = {
        clues = { };

        triggers = { };

        window = {
          config = { };

          delay = 1000;

          scroll_down = "<C-d>";
          scroll_up = "<C-u>";
        };
      };

    };
  };
}
