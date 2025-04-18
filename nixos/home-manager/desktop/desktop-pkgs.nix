{ pkgs, pkgs-unstable, inputs, ... }: {
  home.packages = with pkgs; [
    inputs.zen-browser.packages."x86_64-linux".default
    qmk
    hunspell
    hunspellDicts.uk_UA
    hunspellDicts.th_TH
    joplin-desktop
    gimp
    orca-slicer
    bambu-studio
    #blender
  ];
}
