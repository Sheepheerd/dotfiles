{ inputs, outputs, lib, config, pkgs, misterioFlake, ... }: {
  # You can import other home-manager modules here
  imports = [ ./desktop.nix ./gtk.nix ./tmux.nix ];

  nixpkgs = {
    # You can add overlays here
    # overlays = [
    #   # Add overlays your own flake exports (from overlays and pkgs dir):
    #   outputs.overlays.additions
    #   outputs.overlays.modifications
    #   outputs.overlays.unstable-packages
    #
    #   # You can also add overlays exported from other flakes:
    #   # neovim-nightly-overlay.overlays.default
    #
    #   # Or define it inline, for example:
    #   # (final: prev: {
    #   #   hi = final.hello.overrideAttrs (oldAttrs: {
    #   #     patches = [ ./change-hello-to-hi.patch ];
    #   #   });
    #   # })
    # ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "sheep";
    homeDirectory = "/home/sheep";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove

    # (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" "CascadiaCode" ]; })
  ];

  programs.home-manager.enable = true;
  programs.git.enable = true;

  systemd.user.startServices = "sd-switch";

}
