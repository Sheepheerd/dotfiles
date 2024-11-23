{ inputs, pkgs, ... }: {

  environment.systemPackages = with pkgs;
    [
      # (chromium.override { enableWideVine = true; })
      youtube-music
    ];
}
