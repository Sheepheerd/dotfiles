{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
	
nixvim.url = "github:Sheepheerd/nixvim";
    };

outputs = { nixpkgs, ... } @ inputs:
  {
    nixosConfigurations.novastar = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
	./firewall.nix
	#./fingerprint-scanner.nix
        ./sound.nix
        #./usb.nix
	./utils.nix
	./terminal-utils.nix
	./display-manager.nix
        ./time.nix
        ./bootloader.nix
        ./nix-settings.nix
         ./auto-upgrade.nix
        ./linux-kernel.nix
        ./screen.nix
        # ./location.nix
        ./theme.nix
        ./fonts.nix
        ./services.nix
         ./printing.nix
        ./hyprland.nix
        ./environment-variables.nix
        ./bluetooth.nix
        ./networking.nix
        ./users.nix
        ./virtualisation.nix
        ./programming-languages.nix
	./vim.nix
	./zsh.nix
];
    };
  };
}


