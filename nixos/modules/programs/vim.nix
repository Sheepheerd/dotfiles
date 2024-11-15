{inputs, pkgs, lib, nixvim, ... }: {


  programs.nixvim = {
  imports = [
    # Importing the NixVim module for NixOS
    inputs.nixvim.nixosModule
  ];
    enable = true;
    # other configurations
  };
}

