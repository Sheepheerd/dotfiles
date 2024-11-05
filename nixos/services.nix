{ pkgs, ... }:

{
  # Systemd services setup
  systemd.packages = with pkgs; [
    auto-cpufreq
  ];

  # Enable Services
  programs.dconf.enable = true;
  services.dbus = {
    enable = true;
    implementation = "broker";
    packages = with pkgs; [
    ];
  };
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  services.tumbler.enable = true;
  services.fwupd.enable = true;
  #services.auto-cpufreq.enable = true;
  services.zerotierone.enable = true;

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
  ];
}
