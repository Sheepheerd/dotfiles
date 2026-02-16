{
  self,
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
      nixvim = true;
    };
  };
in
{

  imports = [
    "${self}/modules/home"
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home.stateVersion = lib.mkForce "25.05";
  solarsystem = lib.recursiveUpdate {
  } sharedOptions;

}
