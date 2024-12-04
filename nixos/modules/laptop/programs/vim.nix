{ inputs, pkgs, lib, northstar, ... }: {

  environment.systemPackages = with pkgs;
    [ inputs.northstar.packages.${pkgs.system}.default ];
  programs.nixvim = {
    enable = true;
    imports = [ inputs.northstar.nixvimModule ];
    # Then configure Nixvim as usual, you might have to lib.mkForce some of the settings
  };
}

