{ self, inputs, ... }:
let
  inherit (self) outputs;
  inherit (outputs) lib;
in
{
  flake =
    { config, ... }:
    {
      overlays = {
        default =
          final: prev:
          let
            additions =
              final: _:
              import "${self}/pkgs" {
                pkgs = final;
                inherit self lib;
              };

            nixpkgs-stable = final: _: {
              stable = import inputs.nixpkgs-stable {
                inherit (final) system;
                config.allowUnfree = true;
              };
            };

          in
          (additions final prev)
          # // (modifications final prev)
          // (nixpkgs-stable final prev)
          # // (nixpkgs-kernel final prev)
          // (inputs.nixgl.overlay final prev);
      };
    };
}
