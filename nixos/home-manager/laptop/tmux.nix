{ config, pkgs, ... }: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    disableConfirmationPrompt = true;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    prefix = "C-a";
    shortcut = "Space";
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    plugins = with pkgs; [

      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_window_status_style "rounded"
        '';
      }

      tmuxPlugins.better-mouse-mode
    ];

    extraConfig = "";

  };

  programs.fzf.tmux = { enableShellIntegration = true; };

}
