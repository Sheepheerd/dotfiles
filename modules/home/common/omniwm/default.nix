{
  lib,
  config,
  ...
}:
let
  # OmniWM validates settings.toml as a whole: CanonicalTOMLConfig.init(from:)
  # decodes every top-level key with `decode`, never `decodeIfPresent`, and the
  # [[hotkeys]] array must carry every assignable action exactly once. A partial
  # file is rejected outright, so a hand-written settings tree is not an option.
  #
  # Instead: keep OmniWM's own canonical output as the baseline and express every
  # deviation from it declaratively below. Refresh the baseline after an OmniWM
  # upgrade (it gains keys between versions) with:
  #
  #   cp ~/.config/omniwm/settings.toml modules/home/common/omniwm/defaults.toml
  #
  baseline = ./defaults.toml;
  haveBaseline = builtins.pathExists baseline;
  defaults = builtins.fromTOML (builtins.readFile baseline);

  # AeroSpace-equivalent bindings, keyed by OmniWM action id.
  rebind = {
    "focus.left" = "Option+H";
    "focus.down" = "Option+J";
    "focus.up" = "Option+K";
    "focus.right" = "Option+L";

    "move.left" = "Option+Shift+H";
    "move.down" = "Option+Shift+J";
    "move.up" = "Option+Shift+K";
    "move.right" = "Option+Shift+L";

    "closeFocusedWindow" = "Option+Q";
    "toggleFullscreen" = "Option+F";
    "toggleFocusedWindowFloating" = "Option+Space";

    # AeroSpace used alt-tab for workspace back-and-forth, so the two Tab
    # bindings swap round compared to OmniWM's defaults.
    "workspaceBackAndForth" = "Option+Tab";
    "focusPrevious" = "Control+Option+Tab";

    # Displaced by the bindings above: move.right took Option+Shift+L, and
    # Option+Shift+F is handed to skhd for Finder (see modules/darwin/services.nix).
    "toggleWorkspaceLayout" = "Option+Shift+W";
    "toggleContainerFullPrimarySpan" = "Option+Shift+E";
  };

  knownIds = map (h: h.id) defaults.hotkeys;
  unknownIds = lib.subtractLists knownIds (lib.attrNames rebind);

  # Two actions on one chord is not a schema error, so OmniWM would accept the
  # file and let one of them silently win. Catch it at eval time instead.
  assignedChords = lib.filter (b: b != "Unassigned") (map (h: h.binding) hotkeys);
  duplicateChords = lib.unique (
    lib.filter (b: lib.count (x: x == b) assignedChords > 1) assignedChords
  );

  # Rewrite bindings in place. Entries are never added or removed: the array has
  # to keep exactly one entry per assignable action.
  hotkeys = map (
    h: h // lib.optionalAttrs (rebind ? ${h.id}) { binding = rebind.${h.id}; }
  ) defaults.hotkeys;

  # Godot's editor and its running game share bundle id org.godotengine.godot.
  # Only the editor and project manager carry "Godot Engine" in the title.
  # More-specific rules win, so the titleRegex rule claims the editor and the
  # bare bundleId rule is left with the game.
  godotRules = [
    {
      bundleId = "org.godotengine.godot";
      layout = "float";
    }
    {
      bundleId = "org.godotengine.godot";
      layout = "tile";
      titleRegex = "Godot Engine";
    }
  ];

  settings =
    lib.recursiveUpdate defaults {
      general = {
        # Dwindle is the BSP layout, closest to AeroSpace's 'tiles'.
        defaultLayoutType = "dwindle";
        ipcEnabled = true;
      };
      gaps = {
        size = 6.0;
        outer = {
          left = 6.0;
          right = 6.0;
          top = 6.0;
          bottom = 6.0;
        };
      };

      # No focused-window border. With this off the gaps above are also the
      # runtime-effective gaps; an enabled border widens them.
      borders.enabled = false;

      # Focus follows the mouse. raiseOnMouseFocus stays false so hovering a
      # window focuses it without pulling it above its neighbours.
      focus.followsMouse = true;

      # No workspace bar along the top.
      workspaceBar.enabled = false;
    }
    # recursiveUpdate replaces lists wholesale, so derive these from the baseline.
    // {
      inherit hotkeys;
      appRules = defaults.appRules ++ godotRules;
    };
in
{
  config = lib.mkIf config.solarsystem.isDarwin {
    assertions = [
      {
        assertion = !haveBaseline || unknownIds == [ ];
        message =
          "omniwm: rebind refers to action ids absent from the baseline: "
          + lib.concatStringsSep ", " unknownIds
          + ". Refresh modules/home/common/omniwm/defaults.toml or fix the ids.";
      }
      {
        assertion = !haveBaseline || duplicateChords == [ ];
        message =
          "omniwm: more than one action bound to: "
          + lib.concatStringsSep ", " duplicateChords;
      }
    ];

    programs.omniwm = {
      enable = true;
      launchd.enable = true;
      settings = lib.mkIf haveBaseline settings;
    };
  };
}
