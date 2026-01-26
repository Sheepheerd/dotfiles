{
  self,
  inputs,
  config,
  lib,
  outputs,
  globals,
  ...
}:
{
  options.solarsystem.modules.home-manager = lib.mkEnableOption "home-manager";
  config = lib.mkIf config.solarsystem.modules.home-manager {
    home-manager = lib.mkIf config.solarsystem.withHomeManager {
      useGlobalPkgs = true;
      useUserPackages = true;
      verbose = true;
      # backupFileExtension =
      #   "backup-"
      #   + pkgs.lib.readFile "${pkgs.runCommand "timestamp" { } "echo -n `date '+%Y%m%d%H%M%S'` > $out"}";
      users."${config.solarsystem.mainUser}".imports = [
        {
          imports = [
            "${self}/profiles/home"
            "${self}/modules/home"
          ];
          home.stateVersion = lib.mkDefault config.system.stateVersion;
        }
      ];
      extraSpecialArgs = {
        inherit (inputs) self;
        inherit
          inputs
          outputs
          globals
          ;
      };
    };
  };
}
