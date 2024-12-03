{ pkgs, inputs, config, ... }: {

  hardware.graphics = { enable = true; };
  hardware.nvidia.package =
    config.boot.kernelPackages.nvidiaPackages.production;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    modesetting.enable = true;

    powerManagement.enable = false;

    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

  };

}
