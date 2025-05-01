{
  programs.ghostty = {
    enable = true;
    # enableZshIntegration = true;
    enableFishIntegration = true;
    settings = {
      term = "xterm-256color";
      theme = "catppuccin-mocha";
      font-size = 12;
      font-family = "JetBrainsMono Nerd Font Mono";

      cursor-style = "block";
      cursor-style-blink = false;

      # shell-integration = "zsh";
      # shell-integration = "fish";
      shell-integration-features = "no-cursor";

      window-decoration = false;
      window-theme = "dark";
      background-opacity = 0;
      window-padding-x = 10;
      window-padding-y = 10;
      gtk-titlebar = true;
      keybind = [ "ctrl+h=goto_split:left" "ctrl+l=goto_split:right" ];
    };
  };

}
