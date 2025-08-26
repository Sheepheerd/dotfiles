{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.solarsystem.modules.amd = lib.mkOption {
    description = "Enable Amd module";
  };

  config = lib.mkIf config.solarsystem.modules.amd {
    hardware.graphics.enable = true;

    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    hardware.graphics.enable32Bit = true;

    hardware.graphics.extraPackages = with pkgs; [
      lact
      amdvlk
      rocmPackages.clr.icd
    ];
    # For 32 bit applications
    hardware.graphics.extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];

    systemd.packages = with pkgs; [ lact ];
    systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  };
}
