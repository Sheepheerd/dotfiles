#
# jovian.nix -- Gaming
#
{
  pkgs,
  config,
  lib,
  ...
}:
let
  # Local user account for auto login
  # Separate and distinct from Steam login
  # Can be any name you like
  gameuser = "sheep";
  jovian-nixos = builtins.fetchGit {
    url = "https://github.com/Jovian-Experiments/Jovian-NixOS";
    ref = "development";
  };
  cfg = config.solarsystem.modules;
in
{
  options.solarsystem.modules.jovian = lib.mkEnableOption "Enable jovian config";

  config = lib.mkIf cfg.jovian {

    system.activationScripts = {
      print-jovian = {
        text = builtins.trace "building the jovian configuration..." "";
      };
    };

    #
    # Imports
    #
    imports = [ "${jovian-nixos}/modules" ];

    #
    # Boot
    #
    boot.kernelParams = [ "amd_pstate=active" ];

    #
    # Hardware
    #
    hardware.xone.enable = true;

    #
    # Jovian
    #
    jovian.hardware.has.amd.gpu = true;

    jovian.steam.enable = true;

    #
    # Packages
    #
    environment.systemPackages = with pkgs; [
      cmake # Cross-platform, open-source build system generator
      steam-rom-manager # App for adding 3rd party games/ROMs as Steam launch items
    ];

    #
    # SDDM
    #
    services.displayManager.sddm.settings = {
      Autologin = {
        Session = "gamescope-wayland.desktop";
        User = "${gameuser}";
      };
    };

    #
    # Services
    #
    # 20251117 - Disabled because of build failure and I don't need it.
    services.orca.enable = false;

    #
    # Steam
    #
    # Set game launcher: gamemoderun %command%
    #   Set this for each game in Steam, if the game could benefit from a minor
    #   performance tweak: YOUR_GAME > Properties > General > Launch > Options
    #   It's a modest tweak that may not be needed. Jovian is optimized for
    #   high performance by default.
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility"; # For systems with AMD GPUs
          gpu_device = 0;
          amd_performance_level = "high";
        };
      };
    };

    programs.steam = {
      enable = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    #
    # Users
    #
    # users = {
    #   groups.${gameuser} = {
    #     name = "${gameuser}";
    #     gid = 10000;
    #   };
    #
    #   # Generate hashed password: mkpasswd -m sha-512
    #   # hashedPassword sets the initial password. Use `passwd` to change it.
    #   users.${gameuser} = {
    #     description = "${gameuser}";
    #     extraGroups = [
    #       "gamemode"
    #       "networkmanager"
    #     ];
    #     group = "${gameuser}";
    #     hashedPassword = "$abc123..."; # <<<--- Generate your own initial hashed password
    #     home = "/home/${gameuser}";
    #     isNormalUser = true;
    #     uid = 10000;
    #   };
    # };
  };
}
