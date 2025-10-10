{
  lib,
  config,
  pkgs,
  minimal,
  ...
}:

let
  cfg = config.solarsystem.modules;
in
{
  options.solarsystem.modules.packages = lib.mkEnableOption "Install packages";

  config = lib.mkIf cfg.packages {
    programs.wireshark.enable = true;
    environment.systemPackages =
      with pkgs;
      lib.optionals (!minimal) [

        # better make for general tasks
        just

        # clang-tools
        arduino-cli
        # bluetooth
        bluez
        nixd
      ];
  };
}
