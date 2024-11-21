{ pkgs, ... }:

{
  # Enable fingerprint scanner
  environment.systemPackages = with pkgs; [
   fprintd
];

  services.fprintd = {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  };
}
