{ pkgs, ... }: {
  programs = {
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      dictionaries = [ pkgs.hunspellDictsChromium.en_US ];
    };
  };
}
