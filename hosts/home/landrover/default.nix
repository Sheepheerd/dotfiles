{
  self,
  inputs,
  outputs,
  minimal,
  lib,
  ...
}:
let
  mainUser = "sheep";
  sharedOptions = {
    inherit mainUser;
    isLaptop = true;
    isNixos = false;
    isLinux = true;
    profiles = {
      reduced = true;
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

  solarsystem = lib.recursiveUpdate {
  } sharedOptions;

}
