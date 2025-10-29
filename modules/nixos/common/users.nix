{
  pkgs,
  config,
  lib,
  minimal,
  ...
}:
{
  options.solarsystem.modules.users = lib.mkEnableOption "user config";
  config = lib.mkIf config.solarsystem.modules.users {

    users = {
      users."${config.solarsystem.mainUser}" = {
        isNormalUser = true;
        description = "goober";
        extraGroups = [
          "wheel"
        ]
        ++ lib.optionals (!minimal) [
          "networkmanager"
          "wireshark"
          "syncthing"
          "docker"
          "audio"
          "dialout"
          "video"
          "vboxusers"
          "libvirtd"
          "scanner"
        ];
      };
    };
  };
}
