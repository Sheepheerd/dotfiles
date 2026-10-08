{
  description = "Gooberhead dotfiles";

  nixConfig = {
    extra-substituters = [
      "https://nixos-apple-silicon.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Builds the M1's fairydust kernel (pkgs/linux-asahi). Pinned by rev so
    # `nix flake update` leaves it alone: the kernel's hash covers the whole
    # stdenv, and every nixpkgs bump would otherwise recompile it. Bump this
    # rev only together with the kernel itself.
    nixpkgs-kernel.url = "github:nixos/nixpkgs/44a91898084f46797b5fac650c7e8c9ac38c43d4";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "https://flakehub.com/f/nix-community/stylix/0.1.1223.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixarr = {
      url = "github:rasmus-kirk/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    artcraft.url = "github:Hy4ri/artcraft-flake";

    nix-x86-on-aarch64 = {
      url = "github:rowanG077/nix-x86-on-aarch64";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-xilinx = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:doronbehar/nix-xilinx";
    };

    nix-matlab = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:doronbehar/nix-matlab";
    };

    nixgl.url = "github:guibou/nixGL";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "https://flakehub.com/f/ryantm/agenix/0.15.0.tar.gz";

    openconnect-sso = {
      url = "github:jcszymansk/openconnect-sso";
      inputs.nixpkgs.follows = "nixpkgs-openconnect-sso";
    };
    nixpkgs-openconnect-sso.url = "github:nixos/nixpkgs/46397778ef1f73414b03ed553a3368f0e7e33c2f";

    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Non-redistributable Asahi peripheral firmware, read straight off the ESP
    # where the Asahi installer put it. Only its hash goes in flake.lock.
    asahi-firmware = {
      url = "path:/boot/vendorfw";
      flake = false;
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    godotdev-nvim = {
      url = "github:Mathijs-Bakker/godotdev.nvim";
      flake = false;
    };

    flake-parts.url = "https://flakehub.com/f/hercules-ci/flake-parts/0.1.406.tar.gz";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./nix/globals.nix
        ./nix/hosts.nix
        ./nix/overlays.nix
        ./nix/lib.nix
        ./nix/formatter.nix
        ./nix/modules.nix
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
}
