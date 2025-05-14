{ pkgs, ... }: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      typescript-language-server
      typescript
      # tailwindcss-language-server
    ];
    plugins = {
      ts-autotag.enable = true;
      typescript-tools = { enable = true; };
      # tailwind-tools = { enable = true; };
    };
  };
}
