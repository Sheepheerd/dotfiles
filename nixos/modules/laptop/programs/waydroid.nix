
{inputs, pkgs, ... }:
{
  virtualisation.waydroid.enable = true;
  boot.kernelPatches = [{
    name = "waydroid";
    patch = null;
    extraConfig = ''
      ANDROID_BINDER_IPC y
      ANDROID_BINDERFS y
      ANDROID_BINDER_DEVICES binder,hwbinder,vndbinder
      CONFIG_ASHMEM y
      CONFIG_ANDROID_BINDERFS y
      CONFIG_ANDROID_BINDER_IPC y
    '';
  }];
}
