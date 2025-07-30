{
  programs.nixvim.plugins = {
    git-conflict = {
      enable = true;
      settings = { default_mappings = true; };
    };
  };
}
