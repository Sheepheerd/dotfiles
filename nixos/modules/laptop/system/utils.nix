{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
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
