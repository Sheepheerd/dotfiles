{
  self,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (config.solarsystem) mainUser;
in
{
  options.solarsystem.modules.general = lib.mkEnableOption "general nix settings";
  config = lib.mkIf config.solarsystem.modules.general {
    nix = lib.mkIf (!config.solarsystem.isNixos) {
      package = lib.mkForce pkgs.nixVersions.nix_2_28;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "ca-derivations"
          "cgroups"
          "pipe-operators"
        ];
        trusted-users = [
          "@wheel"
          "${mainUser}"
        ];
        connect-timeout = 5;
        bash-prompt-prefix = "[33m$SHLVL:\\w [0m";
        bash-prompt = "$(if [[ $? -gt 0 ]]; then printf \"[31m\"; else printf \"[32m\"; fi)λ [0m";
        fallback = true;
        min-free = 128000000;
        max-free = 1000000000;
        auto-optimise-store = true;
        warn-dirty = false;
        max-jobs = 1;
        use-cgroups = lib.mkIf config.solarsystem.isLinux true;
      };
    };

    nixpkgs.overlays = lib.mkIf config.solarsystem.isNixos (lib.mkForce null);

    programs.home-manager.enable = lib.mkIf (!config.solarsystem.isNixos) true;
    targets.genericLinux.enable = lib.mkIf (!config.solarsystem.isNixos) true;

    home = {
      username = lib.mkDefault mainUser;
      homeDirectory = lib.mkDefault "/home/${mainUser}";
      stateVersion = lib.mkDefault "25.05";
      keyboard.layout = "us";
      sessionVariables = {
        FLAKE = "/home/${mainUser}/.dotfiles";
      };
    };
  };

}
