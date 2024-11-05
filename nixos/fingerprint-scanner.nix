{ pkgs, ... }:

{
  # Enable fingerprint scanner
{ nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
             "libfprint-2-tod1-goodix-550a"
           ];
         }
  services.fprintd = {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-goodix-550a;
  };
}
