{
  programs.nixvim = {
    plugins.harpoon = {
      enable = false;
      enableTelescope = true;
      keymapsSilent = true;

      keymaps = {
        addFile = "<leader>ha";
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
