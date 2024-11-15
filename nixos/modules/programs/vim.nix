{config, pkgs, inputs, lib, nixvim, ...}:
{

imports = [ inputs.nixvim.nixvimModule ];

environment.systemPackages = with pkgs; [
  inputs.Neve.packages.${pkgs.system}.default
];

programs.nixvim = {
  enable = true;
  imports = [ inputs.Neve.nixvimModule ];
# Then configure Nixvim as usual, you might have to lib.mkForce some of the settings
  colorschemes.catppuccin.enable = lib.mkForce false;
  colorschemes.nord.enable = lib.mkForce false;
};

}
