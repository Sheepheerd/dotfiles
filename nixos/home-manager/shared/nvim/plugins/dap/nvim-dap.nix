{ config, lib, pkgs, ... }:
let
  codelldb-config = {
    name = "Launch (CodeLLDB)";
    type = "codelldb";
    request = "launch";
    program.__raw = ''
      function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. '/', "file")
      end
    '';
    cwd = "\${workspaceFolder}";
    stopOnEntry = false;
  };

  coreclr-config = {
    type = "coreclr";
    name = "launch - netcoredbg";
    request = "launch";
    progra.__raw = ''
      function()
        if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
          vim.g.dotnet_build_project()
        end

        return vim.g.dotnet_get_dll_path()
      end'';
    cwd = "\${workspaceFolder}";
  };

  netcoredb-config = coreclr-config;

  gdb-config = {
    name = "Launch (GDB)";
    type = "gdb";
    request = "launch";
    program.__raw = ''
      function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. '/', "file")
      end'';
    cwd = "\${workspaceFolder}";
    stopOnEntry = false;
  };

  lldb-config = {
    name = "Launch (LLDB)";
    type = "lldb";
    request = "launch";
    program.__raw = ''
      function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. '/', "file")
      end'';
    cwd = "\${workspaceFolder}";
    stopOnEntry = false;
  };

  sh-config = lib.mkIf pkgs.stdenv.isLinux {
    type = "bashdb";
    request = "launch";
    name = "Launch (BashDB)";
    showDebugOutput = true;
    pathBashdb = "${lib.getExe pkgs.bashdb}";
    pathBashdbLib = "${pkgs.bashdb}/share/basdhb/lib/";
    trace = true;
    file = "\${file}";
    program = "\${file}";
    cwd = "\${workspaceFolder}";
    pathCat = "cat";
    pathBash = "${lib.getExe pkgs.bash}";
    pathMkfifo = "mkfifo";
    pathPkill = "pkill";
    args = { };
    env = { };
    terminalKind = "integrated";
  };
in {

  programs.nixvim = {
    globals = {
      dotnet_build_project.__raw = ''
        function()
          local default_path = vim.fn.getcwd() .. '/'

          if vim.g['dotnet_last_proj_path'] ~= nil then
              default_path = vim.g['dotnet_last_proj_path']
          end

          local path = vim.fn.input('Path to your *proj file', default_path, 'file')

          vim.g['dotnet_last_proj_path'] = path

          local cmd = 'dotnet build -c Debug ' .. path .. ' > /dev/null'

          print("")
          print('Cmd to execute: ' .. cmd)

          local f = os.execute(cmd)

          if f == 0 then
              print('\nBuild: ✔️ ')
          else
              print('\nBuild: ❌ (code: ' .. f .. ')')
          end
        end
      '';

      dotnet_get_dll_path.__raw = ''
        function()
          local request = function()
              return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
          end

          if vim.g['dotnet_last_dll_path'] == nil then
              vim.g['dotnet_last_dll_path'] = request()
          else
              if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
                  vim.g['dotnet_last_dll_path'] = request()
              end
          end

          return vim.g['dotnet_last_dll_path']
        end
      '';
    };
    extraPackages = with pkgs;
      [ coreutils lldb netcoredbg ]
      ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.gdb pkgs.bashdb ];

    #   extraPlugins = with pkgs.vimPlugins; [ nvim-gdb ];

    plugins = {

      dap = {
        enable = true;
        # TODO: # TODO: upgrade to mkNeovimPlugin
        # lazyLoad.enable = true;

        adapters = {
          executables = {
            bashdb = lib.mkIf pkgs.stdenv.isLinux {
              command = lib.getExe pkgs.bashdb;
            };

            cppdbg = {
              command = "gdb";
              args = [ "-i" "dap" ];
            };

            gdb = {
              command = "gdb";
              args = [ "-i" "dap" ];
            };

            lldb = {
              command = lib.getExe' pkgs.lldb
                (if pkgs.stdenv.isLinux then "lldb-dap" else "lldb-vscode");
            };

            coreclr = {
              command = lib.getExe pkgs.netcoredbg;
              args = [ "--interpreter=vscode" ];
            };

            netcoredbg = {
              command = lib.getExe pkgs.netcoredbg;
              args = [ "--interpreter=vscode" ];
            };
          };

          servers = {
            codelldb = lib.mkIf pkgs.stdenv.isLinux {
              port = 13000;
              executable = {
                command =
                  "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
                args = [ "--port" "13000" ];
              };
            };
          };
        };

        configurations = {
          c = [ lldb-config ]
            ++ lib.optionals pkgs.stdenv.isLinux [ gdb-config ];

          cpp = [ lldb-config ]
            ++ lib.optionals pkgs.stdenv.isLinux [ gdb-config codelldb-config ];

          cs = [ coreclr-config netcoredb-config ];

          fsharp = [ coreclr-config netcoredb-config ];

          rust = [ lldb-config ]
            ++ lib.optionals pkgs.stdenv.isLinux [ gdb-config codelldb-config ];

          sh = lib.optionals pkgs.stdenv.isLinux [ sh-config ];
        };

        extensions = {
          dap-ui = { enable = true; };

          dap-virtual-text = { enable = true; };
        };

        signs = {
          dapBreakpoint = {
            text = "";
            texthl = "DapBreakpoint";
          };
          dapBreakpointCondition = {
            text = "";
            texthl = "dapBreakpointCondition";
          };
          dapBreakpointRejected = {
            text = "";
            texthl = "DapBreakpointRejected";
          };
          dapLogPoint = {
            text = "";
            texthl = "DapLogPoint";
          };
          dapStopped = {
            text = "";
            texthl = "DapStopped";
          };
        };
      };

    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>dB";
        action =
          "\n        <cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>\n      ";
        options = {
          silent = true;
          desc = "Breakpoint Condition";
        };
      }
      {
        mode = "n";
        key = "<leader>db";
        action = ":DapToggleBreakpoint<cr>";
        options = {
          silent = true;
          desc = "Toggle Breakpoint";
        };
      }
      {
        mode = "n";
        key = "<leader>dc";
        action = ":DapContinue<cr>";
        options = {
          silent = true;
          desc = "Continue";
        };
      }
      {
        mode = "n";
        key = "<leader>da";
        action = "<cmd>lua require('dap').continue({ before = get_args })<cr>";
        options = {
          silent = true;
          desc = "Run with Args";
        };
      }
      {
        mode = "n";
        key = "<leader>dC";
        action = "<cmd>lua require('dap').run_to_cursor()<cr>";
        options = {
          silent = true;
          desc = "Run to cursor";
        };
      }
      {
        mode = "n";
        key = "<leader>dg";
        action = "<cmd>lua require('dap').goto_()<cr>";
        options = {
          silent = true;
          desc = "Go to line (no execute)";
        };
      }
      {
        mode = "n";
        key = "<leader>di";
        action = ":DapStepInto<cr>";
        options = {
          silent = true;
          desc = "Step into";
        };
      }
      {
        mode = "n";
        key = "<leader>dj";
        action = "\n        <cmd>lua require('dap').down()<cr>\n      ";
        options = {
          silent = true;
          desc = "Down";
        };
      }
      {
        mode = "n";
        key = "<leader>dk";
        action = "<cmd>lua require('dap').up()<cr>";
        options = {
          silent = true;
          desc = "Up";
        };
      }
      {
        mode = "n";
        key = "<leader>dl";
        action = "<cmd>lua require('dap').run_last()<cr>";
        options = {
          silent = true;
          desc = "Run Last";
        };
      }
      {
        mode = "n";
        key = "<leader>do";
        action = ":DapStepOut<cr>";
        options = {
          silent = true;
          desc = "Step Out";
        };
      }
      {
        mode = "n";
        key = "<leader>dO";
        action = ":DapStepOver<cr>";
        options = {
          silent = true;
          desc = "Step Over";
        };
      }
      {
        mode = "n";
        key = "<leader>dp";
        action = "<cmd>lua require('dap').pause()<cr>";
        options = {
          silent = true;
          desc = "Pause";
        };
      }
      {
        mode = "n";
        key = "<leader>dr";
        action = ":DapToggleRepl<cr>";
        options = {
          silent = true;
          desc = "Toggle REPL";
        };
      }
      {
        mode = "n";
        key = "<leader>ds";
        action = "<cmd>lua require('dap').session()<cr>";
        options = {
          silent = true;
          desc = "Session";
        };
      }
      {
        mode = "n";
        key = "<leader>dt";
        action = ":DapTerminate<cr>";
        options = {
          silent = true;
          desc = "Terminate";
        };
      }
      {
        mode = "n";
        key = "<leader>du";
        action = "<cmd>lua require('dapui').toggle()<cr>";
        options = {
          silent = true;
          desc = "Dap UI";
        };
      }
      {
        mode = "n";
        key = "<leader>dw";
        action = "<cmd>lua require('dap.ui.widgets').hover()<cr>";
        options = {
          silent = true;
          desc = "Widgets";
        };
      }
      {
        mode = [ "n" "v" ];
        key = "<leader>de";
        action = "<cmd>lua require('dapui').eval()<cr>";
        options = {
          silent = true;
          desc = "Eval";
        };
      }
    ];
  };
}
