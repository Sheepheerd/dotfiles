{ pkgs, ... }: {
  virtualisation.vmware.host.enable = true;
  # Specify the desired packages to install in the user environment.
  environment.systemPackages = with pkgs; [
    vmware-workstation
    prismlauncher
    glfw-wayland-minecraft
  ];
}
