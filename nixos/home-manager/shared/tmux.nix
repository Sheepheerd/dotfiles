{ config, pkgs, ... }: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    newSession = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";

    extraConfig = "";

  };

  programs.fzf.tmux = { enableShellIntegration = true; };

}
