{
  programs.nixvim = {
    plugins.harpoon = {
      enable = true;

      keymapsSilent = true;

      keymaps = {
        addFile = "<leader>h";
        toggleQuickMenu = "<C-e>";
        navFile = {
          "1" = "<C-j>";
          "2" = "<C-k>";
          "3" = "<C-l>";
          "4" = "<C-m>";
        };
      };
    };
  };
}
