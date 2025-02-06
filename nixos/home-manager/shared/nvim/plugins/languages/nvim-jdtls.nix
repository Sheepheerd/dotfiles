{ pkgs, ... }:

let
  javaDebugPath = pkgs.vscode-extensions.vscjava.vscode-java-debug;
  javaTestPath = pkgs.vscode-extensions.vscjava.vscode-java-test;

  # Get all .jar files in the java-debug and java-test directories
  debugJarFiles = builtins.attrNames (builtins.readDir
    "${javaDebugPath}/share/vscode/extensions/vscjava.vscode-java-debug/server");
  debugJarPaths = map (name:
    "${javaDebugPath}/share/vscode/extensions/vscjava.vscode-java-debug/server/${name}")
    debugJarFiles;

  testJarFiles = builtins.attrNames (builtins.readDir
    "${javaTestPath}/share/vscode/extensions/vscjava.vscode-java-test/server");
  testJarPaths = map (name:
    "${javaTestPath}/share/vscode/extensions/vscjava.vscode-java-test/server/${name}")
    testJarFiles;

  # Merge both lists
  allBundles = debugJarPaths ++ testJarPaths;
in {
  programs.nixvim = {

    extraPackages = with pkgs; [
      java-language-server
      vscode-extensions.vscjava.vscode-java-test
      vscode-extensions.vscjava.vscode-java-debug
    ];
    plugins.nvim-jdtls = {
      enable = true;
      cmd = [ "jdtls" ];
      configuration =
        "{pkgs.java-language-server}/share/java/jdtls/config_linux/config.ini";
      data = "~/.cache/jdtls/workspace";
      settings = {
        java = {
          maven = { downloadSource = true; };
          signatureHelp = true;
          completion = {
            favortieStaticMemebers = [
              "org.hamcrest.MatcherAssert.assertThat"
              "org.hamcrest.Matchers.*"
              "org.hamcrest.CoreMatchers.*"
              "org.junit.jupiter.api.Assertions.*"
              "java.util.Objects.requireNonNull"
              "java.util.Objects.requireNonNullElse"
              "org.mockito.Mockito.*"
            ];
          };
        };
      };
      initOptions = { bundles = allBundles; };
    };
  };
}

#   extraOptions = ''
#     local jdtls = require("jdtls")
#     local cmp_nvim_lsp = require("cmp_nvim_lsp")
#
#     local root_dir = require("jdtls.setup").find_root({ "packageInfo" }, "Config")
#     local home = os.getenv("HOME")
#     local eclipse_workspace = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
#
#     local ws_folders_jdtls = {}
#     if root_dir then
#      local file = io.open(root_dir .. "/.bemol/ws_root_folders")
#      if file then
#       for line in file:lines() do
#        table.insert(ws_folders_jdtls, "file://" .. line)
#       end
#       file:close()
#      end
#     end
#
#     -- for completions
#     local client_capabilities = vim.lsp.protocol.make_client_capabilities()
#     local capabilities = cmp_nvim_lsp.default_capabilities(client_capabilities)
#
#     local config = {
#      capabilities = capabilities,
#      cmd = {
#       "${pkgs.jdt-language-server}/bin/jdtls",
#       "--jvm-arg=-javaagent:" .. home .. "/Developer/lombok.jar",
#       "-data",
#       eclipse_workspace,
#       "--add-modules=ALL-SYSTEM",
#      },
#      root_dir = root_dir,
#      init_options = {
#       workspaceFolders = ws_folders_jdtls,
#      },
#      settings = {
#        java = {
#          signatureHelp = { enabled = true},
#          completion = { enabled = true },
#        },
#      },
#      on_attach = function(client, bufnr)
#         local opts = { silent = true, buffer = bufnr }
#         vim.keymap.set('n', "<leader>lo", jdtls.organize_imports, { desc = 'Organize imports', buffer = bufnr })
#         vim.keymap.set('n', "<leader>df", jdtls.test_class, opts)
#         vim.keymap.set('n', "<leader>dn", jdtls.test_nearest_method, opts)
#         vim.keymap.set('n', '<leader>rv', jdtls.extract_variable_all, { desc = 'Extract variable', buffer = bufnr })
#         vim.keymap.set('n', '<leader>rc', jdtls.extract_constant, { desc = 'Extract constant', buffer = bufnr })
#       end
#     }
#
#     jdtls.start_or_attach(config)
#   '';
# }

#
