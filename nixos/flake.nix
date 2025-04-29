{
  description = "Nixos config flake";

  inputs = {

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
    northstar.url = "github:Sheepheerd/northstar";
    # nixvim = {
    #   url = "github:nix-community/nixvim";
    #   inputs.nixpkgs.follows = "stable";
    # };
    ghostty = { url = "github:ghostty-org/ghostty"; };
    nixos-aarch64-widevine.url = "github:epetousis/nixos-aarch64-widevine";
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";

  };

  outputs = { self, nixpkgs, unstable, stable, home-manager, apple-silicon
    , nixos-aarch64-widevine, ghostty, alacritty-theme, nixgl, zen-browser, ...
    }@inputs:
    let
      inherit (self) outputs;

      systems = [ "aarch64-linux" "x86_64-linux" ];
      pkgs = import nixpkgs { overlays = [ nixgl.overlay ]; };
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
            {
              nixpkgs.overlays = [
                nixos-aarch64-widevine.overlays.default
                alacritty-theme.overlays.default
              ];
            }
          ];
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
        "sheep@novastar" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          modules = [
            ./home-manager/laptop/home.nix
            {
              nixpkgs.overlays = [
                nixos-aarch64-widevine.overlays.default
                alacritty-theme.overlays.default
              ];
              home.packages = [
                pkgs.nixgl.nixGLIntel
                stable.legacyPackages.aarch64-linux.texpresso
                stable.legacyPackages.aarch64-linux.tectonic

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

            inherit stable;
          };
        };
        "sheep@deathstar" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home-manager/desktop/home.nix
            {
              nixpkgs.overlays = [ alacritty-theme.overlays.default ];
              home = {
                username = "sheep";
                homeDirectory = "/home/sheep";
              };
              home.packages = [
                stable.legacyPackages.x86_64-linux.texpresso
                stable.legacyPackages.x86_64-linux.tectonic
              ]; # Full TeX Live suite
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
