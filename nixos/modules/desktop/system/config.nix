{ pkgs, config, ... }:

{
  #Pkgs

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

    wlsunset
    brightnessctl
    pamixer
    pavucontrol

    numix-icon-theme-circle
    colloid-icon-theme
    catppuccin-gtk
    catppuccin-kvantum

    # gnome.gnome-tweaks
    # gnome.gnome-shell
    # gnome.gnome-shell-extensions
    # xsettingsd
    # themechanger

    # Enable USB-specific packages
    usbutils

    overskride

  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.timeout = 2;
  boot.initrd.enable = true;
  boot.initrd.systemd.enable = true;
  boot.consoleLogLevel = 3;
  boot.plymouth = {
    enable = true;
    font =
      "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
    themePackages = [ pkgs.catppuccin-plymouth ];
    theme = "catppuccin-macchiato";
  };

  # Display manager
  services.displayManager.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  xdg.portal.enable = true;

  # File systems
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/6cbcf132-63ad-4451-acd5-5a85291d6a41";
    fsType = "ext4";
    options = [ "nofail" ];

  };
  fileSystems."/mnt/movies" = {
    device = "10.147.17.9:/hdd/Plex/media";
    fsType = "nfs";

    options = [
      "x-systemd.idle-timeout=20"
    ]; # disconnects after 10 minutes (i.e. 600 seconds)
  };

  #Firewall
  networking.firewall.enable = true;

  #Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-font-patcher
    noto-fonts-color-emoji
  ];

  # Kernel
  # Linux Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelParams = [
  #   "splash"
  #   "quiet"
  #   "fbcon=nodefer"
  #   "vt.global_cursor_default=0"
  #   "kernel.modules_disabled=1"
  #   "lsm=landlock,lockdown,yama,integrity,apparmor,bpf,tomoyo,selinux"
  #   "usbcore.autosuspend=-1"
  #   "video4linux"
  #   "acpi_rev_override=5"
  #   "security=selinux"
  # ];

  # systemd.package = pkgs.systemd.override { withSelinux = true; };

  # environment.systemPackages = with pkgs; [ policycoreutils ];

  # Enable networking
  networking.hostName = "deathstar"; # Define your hostname.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.
  # networking.networkmanager.wifi.backend = "iwd";

  # Nvidia
  hardware.graphics = { enable = true; };
  hardware.nvidia.package =
    config.boot.kernelPackages.nvidiaPackages.production;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    modesetting.enable = true;

    powerManagement.enable = false;

    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

  };

  #Printing
  services.printing.enable = true;

  #Screen
  programs.light.enable = true;

  # Systemd services setup
  systemd.packages = with pkgs; [ auto-cpufreq ];

  # Enable Services
  programs.xfconf.enable = true;
  services = {
    tailscale.enable = true;
    blueman.enable = true;

    gvfs.enable = true;
    tumbler.enable = true;
    fwupd.enable = true;
    #auto-cpufreq.enable = true;
    # tlp.enable = true;
    zerotierone.enable = true;

  };

  systemd = {
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;

    };
  };
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
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
  };

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

  # Sound
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  #Theme
  #environment.variables.GTK_THEME = "catppuccin-macchiato-teal-standard";
  qt.enable = true;
  qt.platformTheme = "gtk2";
  qt.style = "gtk2";
  console = {
    earlySetup = true;
    colors = [
      "24273a"
      "ed8796"
      "a6da95"
      "eed49f"
      "8aadf4"
      "f5bde6"
      "8bd5ca"
      "cad3f5"
      "5b6078"
      "ed8796"
      "a6da95"
      "eed49f"
      "8aadf4"
      "f5bde6"
      "8bd5ca"
      "a5adcb"
    ];
  };

  # Override packages
  nixpkgs.config.packageOverrides = pkgs: {
    colloid-icon-theme =
      pkgs.colloid-icon-theme.override { colorVariants = [ "teal" ]; };
    catppuccin-gtk = pkgs.catppuccin-gtk.override {
      accents = [
        "teal"
      ]; # You can specify multiple accents here to output multiple themes
      size = "standard";
      variant = "macchiato";
    };
    discord = pkgs.discord.override {
      withOpenASAR = true;
      withTTS = true;
    };
  };

  # Set your time zone.
  time.hardwareClockInLocalTime = true;
  time.timeZone = "America/New_York";

  #USB
  # Enable USB Guard
  services.usbguard = {
    enable = true;
    dbus.enable = true;
    implicitPolicyTarget = "block";
    # FIXME: set yours pref USB devices (change {id} to your trusted USB device), use `lsusb` command (from usbutils package) to get list of all connected USB devices including integrated devices like camera, bluetooth, wifi, etc. with their IDs or just disable `usbguard`
    rules = ''
      allow id {id} # device 1
      allow id {id} # device 2
    '';
  };

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

}
