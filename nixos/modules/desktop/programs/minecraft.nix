{ pkgs, ... }: {
  # Specify the desired packages to install in the user environment.
  environment.systemPackages = with pkgs; [
    prismlauncher
    glfw-wayland-minecraft
  ];
}
