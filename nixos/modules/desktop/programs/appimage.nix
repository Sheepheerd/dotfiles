{ inputs, pkgs, ... }:

{

  programs.appimage = {
    binfmt = true;
    enable = true;
  };
  environment.systemPackages = with pkgs; [ appimage-run ];
}
