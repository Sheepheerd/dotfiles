{ config, pkgs, ... }:

{

  programs.dconf.enable = true;

  users.users.sheep.extraGroups = [ "libvirtd" "kvm" ];
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    gnome.adwaita-icon-theme
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMF.fd ];
      };
    };
  };
  services.spice-vdagentd.enable = true;

}
