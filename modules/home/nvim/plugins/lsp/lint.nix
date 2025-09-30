{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      # statix
      # checkstyle
      # statix
      # pylint
      # cpplint
      # eslint_d
      # # selene
      # golangci-lint
    ];
    plugins.lint = {
      enable = false;
      lintersByFt = {
        c = [ "clangtidy" ];
        cpp = [ "clangtidy" ];
        go = [ "golangci-lint" ];
        nix = [ "statix" ];
        # lua = [ "selene" ];
        # python = [ "pylint" ];
        javascript = [ "eslint_d" ];
        javascriptreact = [ "eslint_d" ];
        typescript = [ "eslint_d" ];
        typescriptreact = [ "eslint_d" ];
        json = [ "jsonlint" ];
        java = [ "checkstyle" ];
        haskell = [ "hlint" ];
        bash = [ "shellcheck" ];
      };
    };
  };
}
