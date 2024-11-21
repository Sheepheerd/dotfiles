{ config, pkgs, home-manager, wide-vine, ... }:

let
  system = pkgs.system;
  homeDir = config.home.homeDirectory;
in {

  home.file.".local/share/applications/chromium-browser.desktop" = {
    enable = system == "aarch64-linux";
    text = ''
      [Desktop Entry]
      Name=Chromium
      GenericName=browser
      Comment=Chromium browser with Widevine
      Exec=${wide-vine.packages.aarch64-linux.chromium-widevine}/bin/chromium
      Terminal=false
      Type=Application
      Keywords=browser;internet;
      Categories=Utility;
    '';
  };

  home.file.".local/share/applications/spotify.desktop" = {
    enable = system == "aarch64-linux";
    text = ''
      [Desktop Entry]
      Name=Spotify
      GenericName=music
      Comment=Listen to Spotify
      Exec=${wide-vine.packages.aarch64-linux.chromium-widevine}/bin/chromium --app=https://open.spotify.com
      Terminal=false
      Type=Application
      Keywords=music;
      Categories=Music;
    '';
  };
}
