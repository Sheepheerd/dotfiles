{
  programs.nixvim = {
    plugins.overseer = { enable = true; };
    plugins.compiler = {
      enable = true;

    };
    keymaps = [
      {
        mode = "n";
        key = "<F6>";
        action = "<cmd>CompilerOpen<CR>";
        options = {
          desc = "Compiler Open";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<F7>";
        action = "<cmd>CompilerRedo<CR>";
        options = {
          desc = "Compiler Redo";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<F5>";
        action = "<cmd>CompilerToggleResults<CR>";
        options = {
          desc = "Compiler Toggle Results";
          silent = true;
        };
      }
    ];

  };
}
