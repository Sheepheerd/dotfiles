{ pkgs, ... }:

{
  programs.zsh.enable = true;
  users.users.sheep = {
    isNormalUser = true;
    description = "Mr. Big Steppa";
    extraGroups = [
      "networkmanager"
      "input"
      "wheel"
      "video"
      "audio"
      "tss"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      vim
    ];
  };

}
