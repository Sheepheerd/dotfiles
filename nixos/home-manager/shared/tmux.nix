{ config, pkgs, ... }: {
  programs.tmux = {
    enable = true;
    baseIndex = 0;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";

  };

  programs.fzf.tmux = { enableShellIntegration = true; };

}
