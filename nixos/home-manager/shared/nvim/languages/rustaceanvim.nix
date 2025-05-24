{
  programs.nixvim = {
    plugins.crates = { enable = true; };
    plugins.rustaceanvim = {
      enable = true;
      settings = {
        tools.float_win_config.border = "rounded";
        # server = {
        #   cmd = [ "rustup" "run" "nightly" "rust-analyzer" ];
        #   default_settings = {
        #     rust-analyzer = {
        #       check = { command = "clippy"; };
        #       inlayHints = { lifetimeElisionHints = { enable = "always"; }; };
        #     };
        #   };
        #   standalone = false;
        # };
      };
    };

  };
}
