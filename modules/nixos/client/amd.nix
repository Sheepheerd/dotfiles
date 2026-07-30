{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.solarsystem.modules.amd = lib.mkEnableOption {
    description = "Enable Amd module";
  };

  config = lib.mkIf config.solarsystem.modules.amd {

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };

    };

    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    boot.kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };

    environment.systemPackages = with pkgs; [
      # lact
      clinfo
    ];

    # systemd.packages = with pkgs; [ lact ];
    # systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  };
}
