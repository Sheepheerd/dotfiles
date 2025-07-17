{ lib, config, ... }:
{
  options.solarsystem.modules.direnv = lib.mkEnableOption "direnv settings";
  config = lib.mkIf config.solarsystem.modules.direnv {
    programs.direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
  };
}
