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
            nixpkgs-stable = final: _: {
              stable = import inputs.nixpkgs-stable {
                inherit (final) system;
                config.allowUnfree = true;
              };
            };
          in
          # merge overlays, now including Matlab
          (nixpkgs-stable final prev)
          // (inputs.nixgl.overlay final prev)
          // (inputs.nix-matlab.overlay final prev)
          // (inputs.nix-xilinx.overlay final prev);
        # // (inputs.nix-firefox-addons.overlays.default final prev);
      };
    };
}
