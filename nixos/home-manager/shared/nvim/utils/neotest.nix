{ pkgs, ... }: {
  programs.nixvim = {
    plugins = {
      neotest = {
        enable = true;
        settings = { discovery = { enabled = true; }; };
        adapters = { java.enable = true; };
      };
    };
    # extraConfigLua = ''
    #    require("neotest").setup({
    #     adapters = {
    #       -- require("neotest-java")({
    #       --   ignore_wrapper = false,
    #       --   -- function to determine which runner to use based on project path
    #       --   determine_runner = function(project_root_path)
    #       --     -- return should be "maven" or "gradle"
    #       --     return "maven"
    #       --   end,
    #       --   -- override the builtin runner discovery behaviour to always use given
    #       --   -- tool. Default is "nil", so no override
    #       --   force_runner = nil,
    #       --   -- if the automatic runner discovery can't uniquely determine whether
    #       --   -- to use Gradle or Maven, fallback to using this runner. Default is
    #       --   -- "maven"
    #       --   fallback_runner = "gradle"
    #       -- }),
    #       require("neotest-python")({
    #       dap = { justMyCode = false },
    #       }),
    #       require "neotest-vim-test" {
    #       ignore_file_types = { "python", "java", "vim", "lua", "javascript", "typescript" },
    #       },
    #     },
    #     output = { enabled = true, open_on_run = true },
    #     summary = { enabled = true, },
    #   })
    # '';
    keymaps = [
      {
        mode = "n";
        key = "<leader>tt";
        action = "<cmd>lua require('neotest').run.run(vim.fn.expand '%')<CR>";
        options = {
          desc = "Run File";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>tT";
        action = "<cmd>lua require('neotest').run.run(vim.loop.cwd())<CR>";
        options = {
          desc = "Run All Test Files";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>tr";
        action = "<cmd>lua require('neotest').run.run()<CR>";
        options = {
          desc = "Run Nearest";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>td";
        action = "<cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>";
        options = {
          desc = "Run Nearest with debugger";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>ts";
        action = "<cmd>lua require('neotest').summary.toggle()<CR>";
        options = {
          desc = "Toggle Summary";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>to";
        action =
          "<cmd>lua require('neotest').output.open{ enter = true, auto_close = true }<CR>";
        options = {
          desc = "Show Output";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>tO";
        action = "<cmd>lua require('neotest').output_panel.toggle()<CR>";
        options = {
          desc = "Toggle Output Panel";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>tS";
        action = "<cmd>lua require('neotest').run.stop()<CR>";
        options = {
          desc = "Stop";
          silent = true;
        };
      }
    ];
  };
}
