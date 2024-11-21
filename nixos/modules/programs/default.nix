
{pkgs, inputs, ...}:
{
  imports = [
  ./hyprland.nix
#  ./spicetify.nix
  ./zsh.nix
  ./vim.nix
#  ./waydroid.nix
./yt_music.nix
];
}
