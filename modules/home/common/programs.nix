{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.solarsystem.modules.programs = lib.mkEnableOption "programs settings";
  config = lib.mkIf config.solarsystem.modules.programs {
    programs = {
      nix-your-shell = {
        enable = true;
        enableZshIntegration = true;
      };
      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batman
          batgrep
          batwatch
        ];
      };
      mpv.enable = true;
      jq.enable = true;
      ripgrep.enable = true;
      fzf.enable = true;
      zoxide = {
        enable = true;
        enableZshIntegration = true;
        options = [
          "--cmd cd"
        ];
      };
    };
  };
}
