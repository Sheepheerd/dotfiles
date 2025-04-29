{ pkgs, ... }:

{
  hardware.keyboard.qmk.enable = true;
  environment.systemPackages = with pkgs; [
    direnv
    gcc
    clang
    lld
    lldb
    jdk
    libinput
    btop
    gvfs

  ];
}
