{ pkgs, inputs, ... }:

{

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sheep = {
    packages = with pkgs; [
      chromium
      vesktop
      firefox
      logisim
      libreoffice
      hunspell
      hunspellDicts.en_US
    ];
  };

}

