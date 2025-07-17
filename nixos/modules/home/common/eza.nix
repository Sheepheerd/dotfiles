{ lib, config, ... }:
{
  options.solarsystem.modules.eza = lib.mkEnableOption "eza settings";
  config = lib.mkIf config.solarsystem.modules.eza {
    programs.eza = {
      enable = true;
      icons = "auto";
      git = true;
      extraOptions = [
        "-l"
        "--group-directories-first"
      ];
    };
  };
}
