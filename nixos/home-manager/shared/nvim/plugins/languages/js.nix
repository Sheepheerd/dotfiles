{ pkgs, ... }: {
  programs.nixvim = {
    extraPackages = with pkgs;
      [
        typescript-language-server
        # tailwindcss-language-server
      ];
    plugins = {
      typescript-tools = { enable = true; };
      # tailwind-tools = { enable = true; };
    };
  };
}
