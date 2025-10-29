{ lib, ... }:
{
  options = {
    solarsystem = {
      withHomeManager = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      rootDisk = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      isImpermanence = lib.mkEnableOption "use impermanence on this system";
    };
  };
}
