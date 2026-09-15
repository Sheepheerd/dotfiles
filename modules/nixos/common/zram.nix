{
  lib,
  config,
  ...
}:

{
  options.solarsystem.modules.zram = lib.mkEnableOption "compressed swap in RAM";

  config = lib.mkIf config.solarsystem.modules.zram {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
    };

    # zram is far cheaper to page to than a disk, so let the kernel actually use it.
    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
  };
}
