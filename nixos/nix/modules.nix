{ ... }:
{
  flake = {
    homeManagerModules = {
      default =
        { ... }:
        {
          imports = [
            ../shared/options.nix
          ];
        };
    };
  };
}
