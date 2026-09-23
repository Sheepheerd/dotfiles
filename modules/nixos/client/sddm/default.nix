{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.services.displayManager.sddm;

  theme = pkgs.runCommandLocal "sddm-theme-minimal" { } ''
    mkdir -p $out/share/sddm/themes
    cp -r ${./theme} $out/share/sddm/themes/minimal
    chmod -R u+w $out/share/sddm/themes/minimal
  '';
in
{
  # Rides along with whoever turned sddm on rather than carrying its own
  # toggle; there is no host that wants sddm and not this theme.
  config = lib.mkIf cfg.enable {
    services.displayManager.sddm.theme = "minimal";

    # sddm resolves theme names against /run/current-system/sw/share/sddm/themes.
    environment.systemPackages = [ theme ];

    # The greeter runs before any user session, so the font it asks for has to
    # be in the system font set, not just in home-manager's.
    fonts.packages = [ pkgs.nerd-fonts.caskaydia-cove ];
  };
}
