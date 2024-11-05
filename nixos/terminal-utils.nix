{ pkgs, ... }:

{

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    file
    upx
    git
    git-ignore
    gitleaks
    git-secrets
    pass-git-helper
    just
    ripgrep
    procs
    macchina #neofetch alternative in rust
    du-dust
    jq
    zoxide
    fzf
    bat
    mdcat
    pandoc

  ];
}
