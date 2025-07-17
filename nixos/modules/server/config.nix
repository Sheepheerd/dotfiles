{ pkgs, ... }:

{

  # Pkgs
  systemd.packages = with pkgs; [
    zerotierone
    poweralertd
    psmisc
    powertop

    auto-cpufreq
    usbutils

    gcc
    clang
    lld
    lldb
    jdk
    libinput
    btop
    gvfs

    qemu
    # docker-compose
    # docker-credential-helpers

  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.timeout = 2;
  boot.initrd.enable = true;
  boot.initrd.systemd.enable = true;
  boot.consoleLogLevel = 3;

  # Firewall
  networking.firewall.enable = true;

  # Fonts
  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      nerd-font-patcher
      noto-fonts-color-emoji
    ];
    fontDir.enable = true;
  };
  # Kernal
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Network
  networking.hostName = "solis";
  networking.networkmanager.enable = true;

  # Printing
  services.printing.enable = false;

  # Services
  systemd = {

    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;

    };
  };
  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
    fwupd.enable = true;
    zerotierone.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    power-profiles-daemon.enable = true;

    tailscale.enable = true;
  };

  programs.dconf.enable = true;
  programs.xfconf.enable = true;

  # Set your time zone.
  time.hardwareClockInLocalTime = true;
  time.timeZone = "America/New_York";

  # USB Automounting
  #services.gvfs.enable = true;
  # services.udisks2.enable = true;
  # services.devmon.enable = true;

  # # Enable USB Guard
  # services.usbguard = {
  #   enable = true;
  #   dbus.enable = true;
  #   implicitPolicyTarget = "block";
  #   # FIXME: set yours pref USB devices (change {id} to your trusted USB device), use `lsusb` command (from usbutils package) to get list of all connected USB devices including integrated devices like camera, bluetooth, wifi, etc. with their IDs or just disable `usbguard`
  #   rules = ''
  #     allow id {id} # device 1
  #     allow id {id} # device 2
  #   '';
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.zsh.enable = true;
  users.users.sheep = {
    isNormalUser = true;
    description = "Mr. Big Steppa";
    extraGroups = [ "networkmanager" "input" "wheel" "video" "audio" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ unzip vim stow ];
  };

  # Virtualisation
  # Enable Containerd
  # virtualisation.containerd.enable = true;

  # Enable Docker
  # virtualisation = {
  #   docker = {
  #     enable = true;
  #     rootless = {
  #       enable = true;
  #       setSocketVariable = true;
  #     };
  #   };
  # };

  users.extraGroups.docker.members = [ "sheep" ];

  # Enable Podman
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
