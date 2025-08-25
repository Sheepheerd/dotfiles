{ lib, config, ... }:
{

  # . /home/sheep/.nix-profile/etc/profile.d/nix.sh
  options.solarsystem.profiles.darwin = lib.mkEnableOption "is this a darwin personal host";
  config = lib.mkIf config.solarsystem.profiles.darwin {
    solarsystem.modules = {
#      packages = lib.mkDefault true;
#      general = lib.mkDefault true;
      # ssh = lib.mkDefault true;
      # env = lib.mkDefault true;
      #direnv = lib.mkDefault true;
      #eza = lib.mkDefault true;
      #git = lib.mkDefault true;
      #zsh = lib.mkDefault true;
      # firefox = lib.mkDefault true;
      # ghostty = lib.mkDefault true;
      #tmux = lib.mkDefault true;
      nixvim = lib.mkDefault true;
      # age = lib.mkDefault true;
    };
  };

}
