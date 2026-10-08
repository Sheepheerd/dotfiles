{
  programs.nixvim = {
    plugins = {
      parinfer-rust.enable = true;
    };
  };
}
