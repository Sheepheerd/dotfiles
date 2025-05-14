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
    # nixgl.url = "github:nix-community/nixGL";
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

      systems = [ "aarch64-linux" "x86_64-linux" ];
      desktop-pkgs = import nixpkgs { system = "x86_64-linux"; };
      laptop-pkgs = import nixpkgs {
        system = "aarch64-linux";
        # overlays = [ nixgl.overlay ];
      };
      pkgs-unstable = unstable.legacyPackages.x86_64-linux;
    in {
      # homeManagerModules = import ./modules/home-manager;

      homeConfigurations = {
        # Used in CI
        "sheep@novastar" = home-manager.lib.homeManagerConfiguration {

          pkgs = laptop-pkgs;
          modules = [
            ./home-manager/laptop/home.nix
            {
              home.packages = [

                # laptop-pkgs.nixgl.nixGLIntel
                # stable.legacyPackages.aarch64-linux.texpresso
                # stable.legacyPackages.aarch64-linux.tectonic

              ]; # Full TeX Live suite
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
            ./home-manager/desktop/home.nix
            {
              home = {
                username = "sheep";
                homeDirectory = "/home/sheep";
              };
              home.packages = [
                # stable.legacyPackages.x86_64-linux.texpresso
                # stable.legacyPackages.x86_64-linux.tectonic
              ];

              programs.home-manager.enable = true;
              targets.genericLinux.enable = true;
              home.stateVersion = "25.05";
            }
          ];
          extraSpecialArgs = {
            inherit inputs;
            # inherit pkgs-unstable;
          };
        };
      };
    };
}
