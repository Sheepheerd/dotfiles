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

    nix = {
      settings = {
        connect-timeout = 5;
        bash-prompt-prefix = "\033[33m$SHLVL:\\w \033[0m";
        bash-prompt = "$(if [[ $? -gt 0 ]]; then printf \"\033[31m\"; else printf \"\033[32m\"; fi)λ \033[0m";
        fallback = true;
        min-free = 128000000;
        max-free = 1000000000;
        flake-registry = "";
        # Deliberately off: it hardlink-dedupes under a global lock on every store
        # write, which stalls builds. nix.optimise.automatic below does it weekly instead.
        auto-optimise-store = false;
        warn-dirty = false;
        # 4x4 saturates the 16 threads on deathstar without the machine going
        # unusable mid-rebuild the way max-jobs=auto with unbounded cores does.
        max-jobs = 4;
        cores = 4;
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
        package = pkgs.nixVersions.nix_2_31;
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

      system.stateVersion = lib.mkDefault "26.05";

      nixpkgs = {
        overlays = [ outputs.overlays.default ];
        config = {
          allowUnfree = true;
        };
      };
    } settings
  );
}
