{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      typescript-language-server
      typescript
    ];
    plugins = {
      ts-autotag.enable = true;
      typescript-tools = {
        enable = true;
      };
    };
  };
}
