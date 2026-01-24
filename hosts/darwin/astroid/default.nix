{
  self,
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}:
let
  mainUser = "sheep";
  # primaryUser = config.solarsystem.mainUser;
  sharedOptions = {
    inherit mainUser;
    isLaptop = true;
    isNixos = false;
    isDarwin = true;
    isLinux = false;
  };
in
{

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
    };
  };
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    overlays = [ outputs.overlays.default ];
    config = {
      allowUnfree = true;
    };
  };

  system.primaryUser = "sheep";
  users.users = {
    sheep = {
      home = "/Users/sheep";
      shell = pkgs.zsh;
      # uid, groups etc as needed
    };
  };

  environment.systemPackages = with pkgs; [
    # firefox
  ];

  home-manager = {

    extraSpecialArgs = { inherit inputs; };

    users."${mainUser}" = {
      home.stateVersion = lib.mkForce "25.11";
      home.username = "sheep";
      programs.home-manager.enable = true;

      imports = [
        "${self}/modules/home"
        "${self}/profiles/home/nixvim"

      ];

      solarsystem = lib.recursiveUpdate {
        profiles = {
          nixvim = true;
        };
        modules.packages = true;
        modules.ghostty = true;
        modules.eza = true;
        modules.direnv = true;
        modules.zsh = true;
        modules.programs = true;
        modules.firefox = true;
      } sharedOptions;
    };
  };

  system.stateVersion = 4;

  imports = [
    "${self}/modules/home/common/sharedsetup.nix"
  ];

  ids.gids.nixbld = 350;
  solarsystem = lib.recursiveUpdate {
    homeDir = "/Users/${mainUser}";
    flakePath = "/Users/${mainUser}/.dotfiles";
  } sharedOptions;

  homebrew = {
    enable = true;
    brews = [
      "x86_64-elf-binutils"
      "x86_64-elf-gcc"
      "tailscale"
    ];
    casks = [
      "ghostty"
      #"nikitabobko/tap/aerospace"
      "vesktop"
      # "firefox"
      "ghdl"
    ];

  };

  # Add ability to use TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    keyboard = {
      #swapLeftCommandAndLeftAlt = true;
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };

    defaults = {
      controlcenter = {
        BatteryShowPercentage = true;
        NowPlaying = false;
      };
      NSGlobalDomain = {
        "com.apple.sound.beep.volume" = 0.000;
        NSWindowShouldDragOnGesture = true;
        AppleKeyboardUIMode = 3;
        "com.apple.keyboard.fnState" = true;
        AppleInterfaceStyle = "Dark";
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 20;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        PMPrintingExpandedStateForPrint = true;
      };
      LaunchServices = {
        LSQuarantine = false;
      };
      trackpad = {
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
        Clicking = true;
      };
      finder = {
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
      };
      dock = {
        autohide = true;
        expose-animation-duration = 0.15;
        show-recents = false;
        showhidden = true;
        persistent-apps = [ ];
        tilesize = 30;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };
    };
  };

}
