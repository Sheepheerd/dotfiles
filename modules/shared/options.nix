{
  lib,
  ...
}:
{
  options.solarsystem = {
    modules = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Custom modules for solarsystem configuration";
    };
    withHomeManager = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    isLaptop = lib.mkEnableOption "laptop host";
    isNixos = lib.mkEnableOption "nixos host";
    isDarwin = lib.mkEnableOption "darwin host";
    isLinux = lib.mkEnableOption "whether this is a linux machine";
    flakePath = lib.mkOption {
      type = lib.types.str;
      default = "/home/sheep/.dotfiles";
    };
  };
}
