{ pkgs, ... }:

{
  # Systemd services setup
  systemd.packages = with pkgs; [ auto-cpufreq ];

  # Enable Services
  programs.dconf.enable = true;
  services.dbus = {
    enable = true;
    implementation = "broker";
    packages = with pkgs; [ ];
  };
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  services.tumbler.enable = true;
  services.fwupd.enable = true;
  #services.auto-cpufreq.enable = true;
  services.tlp.enable = true;
  services.zerotierone.enable = true;
  #services.power-profiles-daemon.enable = true;

  powerManagement.powertop.enable = true;

  #   evdev:name:SynPS/2 Synaptics TouchPad:dmi:*svnLENOVO:*pvrThinkPadT14Gen2a**
  #  EVDEV_ABS_00=::44
  #  EVDEV_ABS_01=::50
  #  EVDEV_ABS_35=::44
  #  EVDEV_ABS_36=::50
  #
  #
  #
  services.udev.extraHwdb = ''
    evdev:name:SynPS/2 Synaptics TouchPad:dmi:*:svnLENOVO*:pvrThinkPadT14Gen2a*:
     EVDEV_ABS_00=:::8
     EVDEV_ABS_01=:::8
     EVDEV_ABS_35=:::8
     EVDEV_ABS_36=:::8

  '';

  environment.systemPackages = with pkgs; [
    zerotierone
    at-spi2-atk
    qt6.qtwayland
    poweralertd
    playerctl
    psmisc
    grim
    slurp
    imagemagick
    wl-clipboard
    wl-clip-persist
    cliphist
    xdg-utils
    waybar
    rofi-wayland
    dunst
    wlogout
    powertop
  ];
}
