{ pkgs, ... }: {
  programs.nixvim = {
    plugins = {

      coq-nvim = {
        enable = true;
        settings = { auto_start = true; };
        # sources = [{
        #   src = "copilot";
        #   short_name = "COP";
        #   accept_key = "<c-f>";
        # }];
      };
    };
  };
}
