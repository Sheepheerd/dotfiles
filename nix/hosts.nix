{ self, inputs, ... }:
{
  flake =
    { config, ... }:
    let
      inherit (self) outputs;
      inherit (outputs) lib;

      mkNixosHost =
        { minimal }:
        configName:
        lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              outputs
              lib
              self
              minimal
              configName
              ;
            inherit (config) globals;
          };
          modules = [
            inputs.agenix.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            "${self}/hosts/nixos/${configName}"
            "${self}/profiles/nixos"
            "${self}/modules/nixos"
          ];

        };

      mkDarwinHost =
        { minimal }:
        configName:
        inputs.nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit
              inputs
              outputs
              lib
              self
              minimal
              configName
              ;
          };
          modules = [
            "${self}/hosts/darwin/${configName}"
            inputs.home-manager.darwinModules.home-manager
            # "${self}/profiles/home/darwin"
          ];
        };

      mkHalfHost =
        { }:
        configName: type: pkgs: {
          ${configName} =
            let
              systemFunc = inputs.home-manager.lib.homeManagerConfiguration;
            in
            systemFunc {
              inherit pkgs;
              extraSpecialArgs = {
                inherit
                  inputs
                  outputs
                  self
                  configName
                  ;
                lib = self.lib;
              };
              modules = [
                "${self}/hosts/${type}/${configName}"
                "${self}/profiles/home"
              ];
            };
        };

      mkHalfHostConfigs =
        {
          hosts,
          type,
          pkgs,
          minimal,
        }:
        lib.foldl (acc: set: acc // set) { } (
          lib.map (name: mkHalfHost ({ minimal = minimal; }) name type pkgs) hosts
        );

      nixosHosts = builtins.attrNames (
        lib.filterAttrs (_: type: type == "directory") (builtins.readDir "${self}/hosts/nixos")
      );
      darwinHosts = builtins.attrNames (
        lib.filterAttrs (_: type: type == "directory") (builtins.readDir "${self}/hosts/darwin")
      );
    in
    {
      nixosConfigurations = lib.genAttrs nixosHosts (mkNixosHost {
        minimal = false;
      });
      nixosConfigurationsMinimal = lib.genAttrs nixosHosts (mkNixosHost {
        minimal = true;
      });
      darwinConfigurations = lib.genAttrs darwinHosts (mkDarwinHost {
        minimal = false;
      });

      # TODO: Build these for all architectures
      homeConfigurations = mkHalfHostConfigs {
        hosts = lib.solarsystem.readHosts "home";
        type = "home";
        pkgs = lib.solarsystem.pkgsFor.aarch64-linux;
        # pkgs = lib.solarsystem.pkgsFor.x86_64-linux;
        minimal = false;
      };

    };
}
