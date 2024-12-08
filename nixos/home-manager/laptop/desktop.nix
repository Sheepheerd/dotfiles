{ config, pkgs, home-manager, misterioFlake, ... }:

let
  system = pkgs.system;
  homeDir = config.home.homeDirectory;
in {

  home.file.".local/share/applications/spotify.desktop" = {
    enable = system == "aarch64-linux";
    text = ''
      [Desktop Entry]
      Name=Spotify
      GenericName=music
      Comment=Listen to Spotify
      Exec=firefox --new-window  https://open.spotify.com
      Terminal=false
      Type=Application
      Keywords=music;
      Categories=Music;
    '';
  };

  home.file.".local/share/applications/joplin.desktop" = {
    enable = system == "aarch64-linux";
    text = ''
      [Desktop Entry]
      Name=Joplin
      GenericName=editor
      Comment=Joplin app image
      Exec=${homeDir}/applications/Joplin.AppImage
      Terminal=false
      Type=Application
      Keywords=editor;
      Categories=Utility;
    '';
  };

}
