{
  lib,
  pkgs,
  config,
  outputs,
  inputs,
  ...
}:
let
  settings = {
    environment.etc."nixos/configuration.nix".source = pkgs.writeText "configuration.nix" ''
      assert builtins.trace "This location is not used. The config is found in ${config.solarsystem.flakePath}!" false;
      { }
    '';

    nix =
      {
        settings = {
          connect-timeout = 5;
          bash-prompt-prefix = "\033[33m$SHLVL:\\w \033[0m";
          bash-prompt = "$(if [[ $? -gt 0 ]]; then printf \"\033[31m\"; else printf \"\033[32m\"; fi)λ \033[0m";
          fallback = true;
          min-free = 128000000;
          max-free = 1000000000;
          flake-registry = "";
          auto-optimise-store = true;
          warn-dirty = false;
          max-jobs = 1;
          use-cgroups = lib.mkIf config.solarsystem.isLinux true;
        };
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 10d";
        };
        optimise = {
          automatic = true;
          dates = "weekly";
        };
        channel.enable = false;
        registry = rec {
          nixpkgs.flake = inputs.nixpkgs;
          n = nixpkgs;
        };
        # nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      };

    services.dbus.implementation = "broker";

    systemd.services.nix-daemon = {
      environment.TMPDIR = "/var/tmp";
    };
  };
in
{
  options.solarsystem.modules.general = lib.mkEnableOption "general nix settings";
  config = lib.mkIf config.solarsystem.modules.general (
    lib.recursiveUpdate {

      nix = {
        package = pkgs.nixVersions.nix_2_30;
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
            "${config.solarsystem.mainUser}"
          ];
        };
      };

      system.stateVersion = lib.mkDefault "25.11";

      nixpkgs = {
        overlays = [ outputs.overlays.default ];
        config = {
          allowUnfree = true;
        };
      };
    } settings
  );
}
