{
  programs.nixvim.plugins.codecompanion = {
    enable = false;
    settings = {
      adapters = {
        gemini = {
          __raw = ''
            require("codecompanion").setup({
              adapters = {
                acp = {
                  gemini_cli = function()
                    return require("codecompanion.adapters").extend("gemini_cli", {
                      env = {
                        api_key = "cmd:op read op://personal/Gemini/credential --no-newline",
                      },
                    })
                  end,
                },
              },
            })
          '';
        };
      };
    };
  };
}
