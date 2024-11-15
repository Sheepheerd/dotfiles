{inputs, pkgs, lib, nixvim, ... }: {

  imports = [
    # Importing the NixVim module for NixOS
    inputs.nixvim.nixosModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    # other configurations
  };
}

