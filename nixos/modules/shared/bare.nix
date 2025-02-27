{ pkgs, inputs, ... }:

{

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [

    git
    git-ignore
    gitleaks
    git-secrets
    git-credential-manager
    pass-git-helper
    macchina # neofetch alternative in rust
    jq
  ];
}
