{ pkgs, ... }:

{
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
