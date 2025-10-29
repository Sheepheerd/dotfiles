{ self, inputs, ... }:
let
  solarsystem =
    let
      inherit (inputs) systems;
      inherit (inputs.nixpkgs) lib;
    in
    rec {
      pkgsFor = lib.genAttrs (import systems) (
        system:
        import inputs.nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
          config.allowUnfree = true;
        }
      );

      forEachLinuxSystem =
        f: lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system: f pkgsFor.${system});

      mkImports = names: baseDir: lib.map (name: "${self}/${baseDir}/${name}") names;
    };
in
{
  flake = _: {
    lib = inputs.nixpkgs.lib.extend (
      _: _: {
        solarsystem = solarsystem;
        hm = inputs.home-manager.lib.hm;
      }
    );
  };
}
