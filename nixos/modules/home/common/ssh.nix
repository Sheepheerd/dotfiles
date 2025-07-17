{ lib, config, ... }:
{
  options.solarsystem.modules.ssh = lib.mkEnableOption "ssh settings";
  config = lib.mkIf config.solarsystem.modules.ssh {
    programs.ssh = {
      enable = true;
      forwardAgent = true;
      extraConfig = ''
        SetEnv TERM=xterm-256color
        ServerAliveInterval 20
      '';
    };
  };
}
