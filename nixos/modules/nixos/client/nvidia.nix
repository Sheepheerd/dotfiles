{ config, lib, ... }:

{
  options.solarsystem.modules.nvidia = lib.mkOption {
    description = "Enable Nvidia module";
  };

  config = lib.mkIf config.solarsystem.modules.nvidia {
    hardware.graphics.enable = true;

    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

    hardware.nvidia.modesetting.enable = true;

    hardware.nvidia.powerManagement.enable = false;

    hardware.nvidia.powerManagement.finegrained = false;

    hardware.nvidia.open = true;

    hardware.nvidia.nvidiaSettings = true;

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}

