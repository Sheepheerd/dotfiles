{ pkgs, inputs, ... }: {
  imports = [ ./config.nix ./users.nix ./utils.nix ./virtualisation.nix ];
}
