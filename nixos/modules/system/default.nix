{pkgs, inputs, ...}:
{
  imports = [
    ./auto-upgrade.nix
    ./bluetooth.nix
    ./bootloader.nix
    ./display-manager.nix
    ./environment-variables.nix
    ./firewall.nix
    ./fonts.nix
    ./internationalisation.nix
    ./linux-kernel.nix
    ./networking.nix
    ./printing.nix
    ./screen.nix
    ./services.nix
    ./sound.nix
    ./theme.nix
    ./time.nix
    #./usb.nix
    ./users.nix
    ./utils.nix
    ./virtualisation.nix
    ];
}