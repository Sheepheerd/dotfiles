{ lib, config, ... }:
{

  # . /home/sheep/.nix-profile/etc/profile.d/nix.sh
  options.solarsystem.profiles.laptop = lib.mkEnableOption "is this a reduced personal host";
  config = lib.mkIf config.solarsystem.profiles.laptop {
    solarsystem.modules = {
      vesktop = lib.mkDefault true;
    };
  };

}
