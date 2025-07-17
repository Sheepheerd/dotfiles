{ inputs, lib, ... }:
let
  # Helper function to define Darwin configurations
  mkDarwinHost =
    configName:
    inputs.nix-darwin.lib.darwinSystem {
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
      specialArgs = { inherit inputs lib; };
    };

  # Helper function to define NixOS configurations
  mkNixosHost =
    { system, configPath }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs lib; };
      modules = [ configPath ];
    };

  # Helper function to define Home Manager configurations
  mkHomeConfig =
    {
      system,
      host,
      modules,
    }:
    inputs.lib.solarsystem.mkHomeConfig {
      inherit system host modules;
    };

  # Define hosts
  darwinHosts = {
    gooberstar = mkDarwinHost "gooberstar";
  };

  nixosHosts = {
    novastar = mkNixosHost {
      system = "aarch64-linux";
      configPath = ../hosts/laptop/configuration.nix;
    };
    deathstar = mkNixosHost {
      system = "x86_64-linux";
      configPath = ../hosts/desktop/configuration.nix;
    };
  };

  homeHosts = {
    novastar = mkHomeConfig {
      system = "aarch64-linux";
      host = "novastar";
      modules = [ ../home-manager/devbox/home.nix ];
    };
    deathstar = mkHomeConfig {
      system = "x86_64-linux";
      host = "deathstar";
      modules = [
        ../home-manager/desktop/home.nix
        { home.packages = with inputs.lib.solarsystem; [ ]; }
      ];
    };
    starcraft = mkHomeConfig {
      system = "x86_64-linux";
      host = "starcraft";
      modules = [ ../home-manager/devbox/home.nix ];
    };
  };
in
{
  flake = {
    darwinConfigurations = darwinHosts;
    nixosConfigurations = nixosHosts;
    homeConfigurations = homeHosts;
  };
}
