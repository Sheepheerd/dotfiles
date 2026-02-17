{ lib, config, ... }:
{

  # . /home/sheep/.nix-profile/etc/profile.d/nix.sh
  options.solarsystem.profiles.darwin = lib.mkEnableOption "is this a darwin personal host";
  config = lib.mkIf config.solarsystem.profiles.darwin {
    solarsystem.modules = {
      packages = lib.mkDefault true;
      ssh = lib.mkDefault true;
      direnv = lib.mkDefault true;
      eza = lib.mkDefault true;
      programs = lib.mkDefault true;
      git = lib.mkDefault true;
      zsh = lib.mkDefault true;
      firefox = lib.mkDefault true;
      ghostty = lib.mkDefault true;
      tmux = lib.mkDefault true;
      # nixvim = lib.mkDefault true;
    };
  };

}
