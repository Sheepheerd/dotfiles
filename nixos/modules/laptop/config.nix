{ pkgs, ... }:

{
  #Pkgs
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    lxqt.lxqt-policykit

    brightnessctl
    pamixer
    pavucontrol

    catppuccin-gtk
    catppuccin-kvantum
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.timeout = 2;
  boot.initrd.enable = true;
  boot.initrd.systemd.enable = true;
  boot.consoleLogLevel = 3;

  # Display manager
  services.displayManager.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  # xdg.portal.enable = true;

  #Firewall
  networking = {
    nameservers = [ "8.8.8.8" ];
    firewall.enable = true;
  };

  # Enable networking
  networking.hostName = "novastar"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  # networking.networkmanager.wifi.backend = "iwd";

  #Screen
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      {
        keys = [ 225 ];
        events = [ "key" ];
        command = "/run/current-system/sw/bin/light -A 5";
      }
      {
        keys = [ 224 ];
        events = [ "key" ];
        command = "/run/current-system/sw/bin/light -U 5";
      }
    ];
  };
  # Systemd services setup

  services = {
    tailscale.enable = true;
    blueman.enable = true;

    gvfs.enable = true;
    tumbler.enable = true;
    fwupd.enable = true;
    #auto-cpufreq.enable = true;
    # tlp.enable = true;
    zerotierone.enable = true;

    resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      fallbackDns = [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
      ];
      dnsovertls = "true";
    };

  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

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
    colloid-icon-theme = pkgs.colloid-icon-theme.override { colorVariants = [ "teal" ]; };
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

}
