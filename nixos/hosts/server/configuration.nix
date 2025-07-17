{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop/default.nix
    ../../modules/shared/default.nix
    ../users.nix
  ];

  environment.systemPackages = with pkgs; [ inputs.home-manager.packages.${pkgs.system}.default ];
  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  services.libinput = {
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";

}
