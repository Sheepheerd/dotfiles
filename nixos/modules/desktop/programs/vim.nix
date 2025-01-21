{ inputs, pkgs, lib, northstar, ... }: {

  environment.systemPackages = with pkgs;
    [ inputs.northstar.packages.${pkgs.system}.default ];
}

