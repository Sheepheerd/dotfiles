{
  self,
  config,
  lib,
  pkgs,
  globals,
  ...
}:
let
  inherit (config.solarsystem) mainUser;
in
{
  options.solarsystem = {
    isLaptop = lib.mkEnableOption "laptop host";
    isNixos = lib.mkEnableOption "nixos host";
    isPublic = lib.mkEnableOption "is a public machine (no secrets)";
    # isDarwin = lib.mkEnableOption "darwin host";
    isLinux = lib.mkEnableOption "whether this is a linux machine";
    # isBtrfs = lib.mkEnableOption "use btrfs filesystem";
    mainUser = lib.mkOption {
      type = lib.types.str;
      default = if (!config.solarsystem.minimal) then globals.user.name else "sheep";
    };
    homeDir = lib.mkOption {
      type = lib.types.str;
      default = "/home/sheep";
    };
    xdgDir = lib.mkOption {
      type = lib.types.str;
      default = "/run/user/1000";
    };
    sopsFile = lib.mkOption {
      type = lib.types.str;
      default = "${config.solarsystem.flakePath}/secrets/nixos/secrets.yaml";
    };

    flakePath = lib.mkOption {
      type = lib.types.str;
      default = "/home/${mainUser}/.dotfiles/";
    };
    # wallpaper = lib.mkOption {
    #   type = lib.types.path;
    #   default = "${self}/files/wallpaper/lenovowp.png";
    # };
    sharescreen = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
    lowResolution = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
    highResolution = lib.mkOption {
      type = lib.types.str;
      default = "";
    };

  };
}
