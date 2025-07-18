{
  self,
  inputs,
  outputs,
  minimal,
  ...
}:
let
  mainUser = "sheep";
  sharedOptions = {
    inherit mainUser;
    isLaptop = false;
    isNixos = false;
    isLinux = true;
    profiles = {
      minimal = true;
    };
  };
in
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

  solarsystem =
    {
    }
      sharedOptions;

}
