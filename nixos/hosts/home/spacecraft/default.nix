{
  self,
  inputs,
  outputs,
  ...
}:
{

  imports = [
    "${self}/modules/home"
  ];

  nixpkgs = {
    # overlays = [ outputs.overlays.default ];
    config = {
      allowUnfree = true;
    };
  };

  solarsystem = {
    isLaptop = false;
    isNixos = false;
    profiles = {
      minimal = true;
    };
    # wallpaper = self + /files/wallpaper/surfacewp.png;
  };

}
