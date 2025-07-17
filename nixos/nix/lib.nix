{
  inputs,
  nixpkgs,
  nixpkgs-stable,
}:

let
  commonSpecialArgs = {
    inherit inputs;
    stablePkgs = import nixpkgs-stable {
      system = nixpkgs.system or "x86_64-linux";
      config.allowUnfree = true;
    };
    systems = {
      "aarch64-linux" = {
        nixgl = inputs.nixgl;
      };
      "x86_64-linux" = { };
      "aarch64-darwin" = { };
    };
  };

  mkHomeConfig =
    {
      system,
      host,
      modules,
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      extraSpecialArgs = commonSpecialArgs // {
        inherit host;
      };
      modules = modules ++ [
        {
          home.stateVersion = "25.05";
          home.username = "sheep";
          home.homeDirectory = if system == "aarch64-darwin" then "/Users/sheep" else "/home/sheep";
        }
      ];
    };

in
{
  inherit commonSpecialArgs mkHomeConfig;
}
