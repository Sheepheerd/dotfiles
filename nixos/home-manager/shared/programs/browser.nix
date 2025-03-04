{ pkgs, ... }: {
  programs = {
    librewolf = {
      enable = true;
      languagePacks = [ "en-US" ];

    };
    chromium = {
      enable = false;
      package = pkgs.ungoogled-chromium;
      dictionaries = [ pkgs.hunspellDictsChromium.en_US ];
    };
  };
}
