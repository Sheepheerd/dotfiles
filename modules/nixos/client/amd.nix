{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.solarsystem.modules.amd = lib.mkEnableOption "Enable Amd module";

  config = lib.mkIf config.solarsystem.modules.amd {
    # This automatically handles the OpenCL ICD and ROCm runtime for you
    hardware.amdgpu.opencl.enable = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa.opencl
      ];
    };

    environment.variables = {
      RUSTICL_ENABLE = "radeonsi";
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "radeonsi";
      # Forces OpenCL to use the stable AMD/ROCm path:
      OCL_ICD_VENDORS = "amdocl64.icd";
    };

    # boot.initrd.kernelModules = [ "amdgpu" ];
    # services.xserver.videoDrivers = [ "amdgpu" ];

    # systemd.tmpfiles.rules = [
    #   "L+    /opt/rocm/hip    -    -    -     -    ${pkgs.rocmPackages.clr}"
    # ];

    environment.systemPackages = with pkgs; [
      lact
      clinfo
      libva-utils # For running 'vainfo' to verify
    ];

    systemd.packages = with pkgs; [ lact ];
    systemd.services.lactd.wantedBy = [ "multi-user.target" ];
  };
}
