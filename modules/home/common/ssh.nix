{ lib, config, ... }:
{
  options.solarsystem.modules.ssh = lib.mkEnableOption "ssh settings";
  config = lib.mkIf config.solarsystem.modules.ssh {
    programs.ssh = {
      enableDefaultConfig = false;
      enable = true;
      settings.default = {
        ForwardAgent = true;
      };
      # extraConfig = ''
      #   SetEnv TERM=xterm-256color
      #   ServerAliveInterval 20
      # '';
    };
  };
}
