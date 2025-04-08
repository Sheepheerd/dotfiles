{ pkgs, ... }:

{
  hardware.keyboard.qmk.enable = true;
  environment.systemPackages = with pkgs; [
    via
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
  services.udev.packages = [ pkgs.via ];
}
