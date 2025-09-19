# adapted from https://github.com/oddlama/nix-config/blob/main/nix/globals.nix
{ inputs, ... }:
{
  flake =
    { lib, ... }:
    {
      globals =
        let
          globalsSystem = lib.evalModules {
            prefix = [ "globals" ];
            specialArgs = {
              inherit lib;
              inherit inputs;
            };
            modules = [
              ../modules/nixos/common/globals.nix
              (
                { ... }:
                {

                }
              )
            ];
          };
        in
        {
          # Make sure the keys of this attrset are trivially evaluatable to avoid infinite recursion,
          # therefore we inherit relevant attributes from the config.
          inherit (globalsSystem.config.globals)
            domains
            services
            user
            ;
        };
    };
}
