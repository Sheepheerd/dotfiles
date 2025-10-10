{ lib, config, ... }:
{
  options.solarsystem.profiles.nixvim = lib.mkEnableOption "nixvim";
  config = lib.mkIf config.solarsystem.profiles.nixvim {
    solarsystem.modules.nixvim = {
      enable = lib.mkDefault true;
      lsp = {
        enable = lib.mkDefault true;
        servers = {
          arduino_language_server = lib.mkDefault true;
          clangd = lib.mkDefault true;
          lua_ls = lib.mkDefault true;
          nil_ls = lib.mkDefault true;
          basedpyright = lib.mkDefault true;
        };
      };
    };
  };
}
