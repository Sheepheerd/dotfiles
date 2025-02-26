{ pkgs, inputs, ... }:

{
  programs.ydotool.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sheep = {
    packages = with pkgs; [
      vesktop
      firefox
      logisim
      # libreoffice
      hunspell
      hunspellDicts.en_US
      # sommelier
    ];
  };

}
