{ pkgs, ... }: {

  # Specify the desired packages to install in the user environment.
  home.packages = with pkgs;
    [
      # prismlauncher

      glfw-wayland-minecraft
    ];
}
