{ inputs, ... }:

{
  flake =
    { ... }:
    let
      inherit (inputs.nixpkgs-stable.lib) composeManyExtensions;

      nixpkgs-stable = final: _: {
        stable = import inputs.nixpkgs-stable {
          inherit (final) system;
          config.allowUnfree = true;
        };
      };
    in
    {
      overlays.default = composeManyExtensions [
        nixpkgs-stable
        inputs.nixgl.overlay
        inputs.artcraft.overlays.default
      ];

      # Heavy proprietary toolchains, opt in per-host (see modules/nixos/client/school.nix)
      overlays.school = composeManyExtensions [
        inputs.nix-matlab.overlay
        inputs.nix-xilinx.overlay
      ];
    };
}
