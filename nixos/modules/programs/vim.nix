{pkgs, inputs, lib, nixvim, ...}:
{

    imports = [ inputs.nixvim.nixvimModule ];

programs.nixvim = {
  enable = true;
  # Then configure Nixvim as usual, you might have to lib.mkForce some of the settings
};

}
