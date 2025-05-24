{
  description = "Gooberhead dotfiles";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    nixgl.url = "github:nix-community/nixGL";
    # northstar.url = "github:Sheepheerd/northstar";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = { url = "github:ghostty-org/ghostty"; };

  };

  outputs = { self, nixpkgs, unstable, stable, home-manager, ghostty, nixgl
    , zen-browser, ... }@inputs:
    let
      inherit (self) outputs;

      desktop-pkgs = import nixpkgs;
      laptop-pkgs = import nixpkgs {
        system = "aarch64-linux";
        overlays = [ nixgl.overlay ];
      };
      pkgs-unstable = unstable.legacyPackages.x86_64-linux;
    in {

      nixosConfigurations = {
        novastar = laptop-pkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
          };
          modules = [ ./hosts/laptop/configuration.nix ];
        };
        deathstar = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
          };
          modules = [ ./hosts/desktop/configuration.nix ];
        };
      };

      homeConfigurations = {
        # Used in CI
        "novastar" = home-manager.lib.homeManagerConfiguration {

          pkgs = laptop-pkgs;
          modules = [
            ./home-manager/laptop/home.nix
            {
              home = {
                packages = [
                  laptop-pkgs.nixgl.nixGLIntel
                  stable.legacyPackages.aarch64-linux.texpresso
                  stable.legacyPackages.aarch64-linux.tectonic
                  # Full TeX Live suite
                ];

                username = "sheep";
                homeDirectory = "/home/sheep";

                stateVersion = "25.05";
              };

              programs.home-manager.enable = true;
              targets.genericLinux.enable = true;
            }
          ];
          extraSpecialArgs = {
            inherit inputs;

            inherit stable;
          };
        };
        "deathstar" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home-manager/desktop/home.nix
            {
              home = {
                username = "sheep";
                homeDirectory = "/home/sheep";

                packages = [
                  stable.legacyPackages.x86_64-linux.texpresso
                  stable.legacyPackages.x86_64-linux.tectonic
                  # Full TeX Live suite

                ];
                stateVersion = "25.05";
              };
              programs.home-manager.enable = true;
              targets.genericLinux.enable = true;
            }
          ];
          extraSpecialArgs = { inherit inputs; };
        };
        "starcraft" = home-manager.lib.homeManagerConfiguration {
          pkgs = desktop-pkgs;
          modules = [
            ./home-manager/devbox/home.nix
            {
              home = {
                username = "sheep";
                homeDirectory = "/home/sheep";
                stateVersion = "25.05";
              };
              programs.home-manager.enable = true;
              targets.genericLinux.enable = true;
            }
          ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
}
