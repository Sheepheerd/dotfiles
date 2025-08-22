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
      laptop = true;
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

  home.stateVersion = lib.mkForce "25.05";
  solarsystem = lib.recursiveUpdate {
    # lowResolution = "1280x800";
    # highResolution = "1920x1080";
  } sharedOptions;
  # solarsystem = lib.recursiveUpdate {
  # } sharedOptions;

}
