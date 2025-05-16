{
  description = "Nixos config flake";

  inputs = {

    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, unstable, stable, home-manager, nixvim,
    # nixgl
    ... }@inputs:
    let
      inherit (self) outputs;

      desktop-pkgs = import nixpkgs { system = "x86_64-linux"; };
      laptop-pkgs = import nixpkgs { system = "aarch64-linux"; };
    in {

      homeConfigurations = {
        # Used in CI
        "sheep@novastar" = home-manager.lib.homeManagerConfiguration {

          pkgs = laptop-pkgs;
          modules = [
            ./home-manager/home.nix
            {
              home = {
                username = "sheep";
                homeDirectory = "/home/sheep";
              };
              programs.home-manager.enable = true;
              targets.genericLinux.enable = true;
              home.stateVersion = "25.05";
            }
          ];
          extraSpecialArgs = {
            inherit inputs;
            inherit stable;
          };
        };
        "sheep@deathstar" = home-manager.lib.homeManagerConfiguration {
          pkgs = desktop-pkgs;
          modules = [
            ./home-manager/home.nix
            {
              home = {
                username = "sheep";
                homeDirectory = "/home/sheep";
              };

              programs.home-manager.enable = true;
              targets.genericLinux.enable = true;
              home.stateVersion = "25.05";
            }
          ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
}
