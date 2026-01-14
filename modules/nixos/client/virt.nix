{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.solarsystem.modules;
in
{
  options.solarsystem.modules.virt = lib.mkEnableOption "Enable virtualization config";

  config = lib.mkIf cfg.virt {
    users.groups.libvirtd.members = [ "sheep" ];
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs; [
      distrobox
    ];

    virtualisation = {
      # docker.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
      };
    };
  };
}
