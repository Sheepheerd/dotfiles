{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.solarsystem.fonts;
in
{
  options.solarsystem.fonts = {
    enable = mkEnableOption "Enable custom fonts configuration";

    fontPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [
        jetbrains-mono
        nerd-font-patcher
        noto-fonts-color-emoji
      ];
      description = "List of font packages to install";
    };

    fontDirEnable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable fontDir for additional font loading";
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      packages = cfg.fontPackages;
      fontDir.enable = cfg.fontDirEnable;
    };
  };
}
