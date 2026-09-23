{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.solarsystem.isDarwin) {

    services = {

      jankyborders = {
        enable = false;
        package = pkgs.jankyborders;
        width = 5.0;
        active_color = "gradient(top_left=0xffDDB6F2,bottom_right=0xff96CDFB)";
        inactive_color = "gradient(top_right=0x9992B3F5,bottom_left=0x9992B3F5)";
        hidpi = true;
        ax_focus = true;
      };

      # OmniWM has no exec/launch action (its only open* actions are
      # openCommandPalette and openMenuAnywhere), so the AeroSpace launcher
      # bindings live here. Chords are kept clear of OmniWM's hotkeys; see
      # modules/home/common/omniwm/default.nix.
      skhd = {
        enable = true;
        skhdConfig = ''
          alt - return : open -na ghostty
          alt - b : open -a Firefox
          shift + alt - f : open -a Finder
        '';
      };

    };

  };
}
