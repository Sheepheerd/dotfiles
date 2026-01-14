{ inputs, ... }:

{
  flake =
    { ... }:
    {
      overlays.default =
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
        composeManyExtensions [
          nixpkgs-stable
          inputs.nixgl.overlay
          inputs.nix-matlab.overlay
          # glaumar-overlay
          # inputs.box64-binfmt.overlays.default
          inputs.nix-xilinx.overlay
        ];
    };
}
