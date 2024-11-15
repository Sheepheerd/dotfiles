{config, pkgs, inputs, lib, ...}:
{

imports = [ inputs.nixvim.nixvimModule ];

environment.systemPackages = with pkgs; [
  inputs.nixvim.packages.${pkgs.system}.default
];

programs.nixvim = {
  enable = true;
# Then configure Nixvim as usual, you might have to lib.mkForce some of the settings
};

}
