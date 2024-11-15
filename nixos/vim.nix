{inputs, pkgs, ... }:
{


programs.nixvim = {
  enable = true;
  imports = [ inputs.nixvim.nixvimModule ];
  # Then configure Nixvim as usual, you might have to lib.mkForce some of the settings
};

};
