{
  programs.nixvim.plugins.copilot-lua = {
    enable = false;
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
