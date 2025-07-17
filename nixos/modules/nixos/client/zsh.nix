{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.solarsystem.modules;
in
{
  options.solarsystem.modules.zsh = lib.mkEnableOption "Enable zsh base config";

  config = lib.mkIf cfg.zsh {
    programs.zsh = {
      enable = true;
      enableCompletion = false;
    };

    users.defaultUserShell = pkgs.zsh;

    environment.shells = with pkgs; [ zsh ];

    environment.pathsToLink = [ "/share/zsh" ];
  };
}
