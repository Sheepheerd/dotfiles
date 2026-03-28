{
  programs.nixvim.plugins.copilot-lua = {
    enable = true;
    settings = {
      panel = {
        enabled = false;
      };
      suggestion = {
        auto_trigger = false;
      };
    };
  };
}
