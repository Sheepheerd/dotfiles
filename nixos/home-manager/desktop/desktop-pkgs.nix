{ pkgs, ... }: {
  home.packages = with pkgs; [

    texlive.combined.scheme-full
    hunspell
    hunspellDicts.uk_UA
    hunspellDicts.th_TH
    joplin-desktop
    localsend
    gimp
    #bambu-studio
    #blender
    # pkgs-unstable.cura
  ];
}
