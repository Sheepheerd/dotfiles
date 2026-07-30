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
      # glaumar-overlay = final: prev: {
      #   glaumar_repo = inputs.glaumar_repo.packages.${prev.system};
      # };
    in
    {
      overlays.default = composeManyExtensions [
        nixpkgs-stable
        # inputs.nixos-muvm-fex.overlays.default
        inputs.nixgl.overlay
        # glaumar-overlay
        # inputs.box64-binfmt.overlays.default
      ];

      # Heavy proprietary toolchains, opt in per-host (see modules/nixos/client/school.nix)
      overlays.school = composeManyExtensions [
        inputs.nix-matlab.overlay
        inputs.nix-xilinx.overlay
      ];
    };
}
