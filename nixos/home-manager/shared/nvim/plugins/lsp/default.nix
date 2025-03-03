{ config, ... }: {
  imports = [
    ./lsp.nix
    ./conform.nix
     ./lspsaga.nix
    ./trouble.nix
    ./lint.nix
  ];
}
