{
  programs.nixvim.plugins = {
    git-conflict = {
      enable = false;
      settings = {
        default_mappings = true;
      };
    };
  };
}
