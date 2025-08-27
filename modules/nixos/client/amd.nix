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

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };

      amdgpu.amdvlk = {
        enable = true;
        support32Bit.enable = true;
      };
    };

    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    environment.systemPackages = with pkgs; [
      lact
      clinfo
    ];

    systemd.packages = with pkgs; [ lact ];
    systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  };
}
