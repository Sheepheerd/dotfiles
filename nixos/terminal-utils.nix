{ pkgs, ... }:

{
  programs.git = {
  enable = true;
  package = pkgs.gitFull;
  config = {
      credential.helper = "libsecret";
  };
};

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    file
    upx
    git
    git-ignore
    gitleaks
    git-secrets
    git-credential-manager
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
