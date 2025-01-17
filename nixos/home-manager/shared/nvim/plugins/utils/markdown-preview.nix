{
  programs.nixvim = {
    plugins.markdown-preview = {
      enable = true;

      settings = {
        browser = "firefox";
        port = "8080";
        auto_close = 1;
        theme = "dark";
        auto_start = 1;
      };
    };
  };
}
