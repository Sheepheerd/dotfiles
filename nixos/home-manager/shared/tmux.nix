{ config, pkgs, ... }: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    newSession = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";

    extraConfig = "";

  };

  programs.fzf.tmux = { enableShellIntegration = true; };

}
