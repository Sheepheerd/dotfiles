{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gcc
    clang
    lld
    lldb
    jdk11
    libinput
];
}
