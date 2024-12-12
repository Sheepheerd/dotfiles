{ pkgs, ... }:

{
  # Systemd services setup
  systemd.packages = with pkgs; [ auto-cpufreq ];

  # Enable Services
  services.blueman.enable = true;

  programs.dconf.enable = true;
  services.dbus = {
    enable = true;
    implementation = "broker";
    packages = with pkgs; [ ];
  };
  # systemd.user.services.easyeffects = {
  #   enable = true;
  #   description = "Sound go good";
  #   unitConfig = { Type = "simple"; };
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
  #     Restart = "always";
  #   };
  #   wantedBy = [ "default.target" ];
  # };
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  services.tumbler.enable = true;
  services.fwupd.enable = true;
  #services.auto-cpufreq.enable = true;
  # services.tlp.enable = true;
  services.zerotierone.enable = true;

  programs.adb.enable = true;
  users.users.sheep.extraGroups = [ "adbusers" ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  #services.power-profiles-daemon.enable = true;

  # powerManagement.powertop.enable = true;

  #   evdev:name:SynPS/2 Synaptics TouchPad:dmi:*svnLENOVO:*pvrThinkPadT14Gen2a**
  #  EVDEV_ABS_00=::44
  #  EVDEV_ABS_01=::50
  #  EVDEV_ABS_35=::44
  #  EVDEV_ABS_36=::50
  #
  #
  #

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
