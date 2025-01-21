{ pkgs, ... }: {
  gtk = {
    enable = true;
    theme.package = pkgs.dracula-theme;
    theme.name = "Dracula";
    cursorTheme.name = "Dracula";
    iconTheme.name = "Dracula";
  };
}
