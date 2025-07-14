{
  inputs,
  ...
}:

let
  lib = import ../modules/lib.nix {
    inherit inputs;
    nixpkgs = inputs.nixpkgs;
    nixpkgs-stable = inputs.nixpkgs-stable;
  };
in
{

  flake = {
    inherit lib;

    darwinConfigurations.gooberstar = inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ../darwin.nix
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.users.sheep = {
            imports = [ ../home-manager/devbox/home.nix ];
          };
          users.users.sheep.home = "/Users/sheep";
        }
      ];
      specialArgs = lib.commonSpecialArgs;
    };

    nixosConfigurations = {
      novastar = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = lib.commonSpecialArgs;
        modules = [ ../hosts/laptop/configuration.nix ];
      };
      deathstar = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = lib.commonSpecialArgs;
        modules = [ ../hosts/desktop/configuration.nix ];
      };
    };

    homeConfigurations = {
      novastar = lib.mkHomeConfig {
        system = "aarch64-linux";
        host = "novastar";
        modules = [
          ../home-manager/devbox/home.nix
        ];
      };
      deathstar = lib.mkHomeConfig {
        system = "x86_64-linux";
        host = "deathstar";
        modules = [
          ../home-manager/desktop/home.nix
          {
            home.packages = with lib; [
            ];
          }
        ];
      };
      starcraft = lib.mkHomeConfig {
        system = "x86_64-linux";
        host = "starcraft";
        modules = [
          ../home-manager/devbox/home.nix
        ];
      };
    };
  };
}
