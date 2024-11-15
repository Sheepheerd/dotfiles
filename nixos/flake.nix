{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    nixvim.url = "github:Sheepheerd/nixvim";
spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

};

outputs = { self, nixpkgs, ... } @ inputs: let
  inherit (self) outputs;

 systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

   perSystem = {
        pkgs,
        system,
        ...
      }: let       nixvim' = nixvim.legacyPackages."${system}";
        nvim = nixvim'.makeNixvim config;
      in {
        packages = {
          inherit nvim;
          default = nvim;
        };
      };
in {

    nixosConfigurations = {
      novastar = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/configuration.nix
      ];
    };
    };
  };
}
