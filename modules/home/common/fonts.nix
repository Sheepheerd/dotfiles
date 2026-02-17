{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.solarsystem.modules.fonts;
in
{
  options.solarsystem.modules.fonts = {
    enable = lib.mkEnableOption "Enable custom fonts configuration";

    fontPackages = lib.mkOption {
      default = with pkgs; [
        corefonts
        noto-fonts
        liberation_ttf
        nerd-fonts.jetbrains-mono
        nerd-fonts.caskaydia-cove
        jetbrains-mono
        nerd-font-patcher
        noto-fonts-color-emoji
      ];
      description = "List of font packages to install";
    };

    fontDirEnable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable fontDir for additional font loading";
    };
  };

  # Enable fonts only if not on a NixOS system
  config = lib.mkIf (config.solarsystem.isNixos != true && config.solarsystem.isDarwin != true) {
    home.packages = cfg.fontPackages;

    fonts.fontconfig.enable = true;

    home.file.".local/share/fonts/fedora-system-fonts" = mkIf cfg.fontDirEnable {
      source = config.lib.file.mkOutOfStoreSymlink "/usr/share/fonts";
    };
  };
}
