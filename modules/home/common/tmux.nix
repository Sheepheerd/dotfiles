{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.solarsystem.modules.tmux;
in
{
  options.solarsystem.modules.tmux = lib.mkEnableOption "Enable and configure tmux";

  config = lib.mkIf cfg {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "tmux-256color";
    };
  };
}
