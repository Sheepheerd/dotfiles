{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    wide-vine.url =  "github:heywoodlh/flakes";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };


#spicetify-nix = {
#      url = "github:Gerg-L/spicetify-nix";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };

};

outputs = { self, nixpkgs, wide-vine, home-manager,  ... } @ inputs: let
  inherit (self) outputs;

 systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

in {
    homeManagerModules = import ./home;


    nixosConfigurations = {
      novastar = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/configuration.nix
];
    };
    };



   homeConfigurations = {
      # Used in CI
      "sheep@novastar" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home.nix # Base desktop config
          ];
      };
   };
  };
}
