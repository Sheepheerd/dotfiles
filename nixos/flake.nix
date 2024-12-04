{
  description = "Nixos config flake";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/master";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    misterioFlake.url = "github:heywoodlh/flakes";
    northstar.url = "github:Sheepheerd/northstar";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";

      # this line prevents me from fetching two versions of nixpkgs:
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      # url = "github:nix-community/nixvim/nixos-24.11";

      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, unstable, misterioFlake, home-manager
    , apple-silicon, nixvim, ... }@inputs:
    let
      inherit (self) outputs;

      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      pkgs-unstable = unstable.legacyPackages.x86_64-linux;
    in {
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        novastar = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
          };
          modules = [
            ./hosts/laptop/configuration.nix

          ];
        };
        deathstar = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
          };
          modules = [
            ./hosts/desktop/configuration.nix

          ];
        };
      };

      homeConfigurations = {
        # Used in CI
        "sheep@novastar" = home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.aarch64-linux; # Home-manager requires 'pkgs' instance
          modules = [
            #./modules/home-manager/desktop.nix # Base desktop config
            ./home-manager/laptop/home.nix # Base desktop config
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
          extraSpecialArgs = inputs;

        };
        "sheep@deathstar" = home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          modules = [
            ./home-manager/desktop/home.nix # Base desktop config
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
          extraSpecialArgs = inputs;

        };
      };
    };
}
