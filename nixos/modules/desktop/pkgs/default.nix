{ pkgs, inputs, ... }:

{

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sheep = {
    packages = with pkgs; [
      vesktop
      firefox
      logisim
      #libreoffice-still
      texlive.combined.scheme-full
      hunspell
      hunspellDicts.uk_UA
      hunspellDicts.th_TH
      joplin-desktop
    ];
  };

}

