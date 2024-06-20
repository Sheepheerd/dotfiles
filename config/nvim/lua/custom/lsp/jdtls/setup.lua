local M = {}

function M.setup()
	local jdtls = require("jdtls")
	local jdtls_dap = require("jdtls.dap")
	local jdtls_setup = require("jdtls.setup")
	local home = os.getenv("HOME")

	local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
	local root_dir = jdtls_setup.find_root(root_markers)

	local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
	local workspace_dir = home .. "/.cache/jdtls/workspace" .. project_name

	-- 💀
	local path_to_mason_packages = home .. "/.local/share/nvim/mason/packages"
	-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^

	local path_to_jdtls = path_to_mason_packages .. "/jdtls"
	local path_to_jdebug = path_to_mason_packages .. "/java-debug-adapter"
	local path_to_jtest = path_to_mason_packages .. "/java-test"

	local path_to_config = path_to_jdtls .. "/config_linux"
	local lombok_path = path_to_jdtls .. "/lombok.jar"

	-- 💀
	local path_to_jar = vim.fn.glob(path_to_jdtls .. "/plugins/org.eclipse.equinox.launcher_*.jar")
	-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^

	local bundles = {
		vim.fn.glob(path_to_jdebug .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
	}

	vim.list_extend(bundles, vim.split(vim.fn.glob(path_to_jtest .. "/extension/server/*.jar", true), "\n"))

	-- LSP settings for Java.
	local on_attach = function(_, bufnr)
		jdtls.setup_dap({ hotcodereplace = "auto" })
		jdtls_dap.setup_dap_main_class_configs()
		jdtls_setup.add_commands()

		local nmap = function(keys, func, desc)
			if desc then
				desc = "LSP: " .. desc
			end

			vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
		end

		-- nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
		-- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

		-- nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
		-- nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
		nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
		nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
		-- nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
		-- nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

		-- See `:help K` for why this keymap
		-- nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
		-- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
		nmap("<leader>hh", vim.lsp.buf.signature_help, "Signature [H][H]elp Documentation")

		-- Lesser used LSP functionality
		nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
		nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
		nmap("<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "[W]orkspace [L]ist Folders")

		-- Create a command `:Format` local to the LSP buffer
		vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
			vim.lsp.buf.format()
		end, { desc = "Format current buffer with LSP" })

		require("lsp_signature").on_attach({
			bind = true,
			padding = "",
			handler_opts = {
				border = "rounded",
			},
			hint_prefix = "󱄑 ",
		}, bufnr)

		require("lspsaga").setup()
	end

	local capabilities = {
		workspace = {
			configuration = true,
		},
		textDocument = {
			completion = {
				completionItem = {
					snippetSupport = true,
				},
			},
		},
	}

	local config = {
		flags = {
			allow_incremental_sync = true,
		},
	}

	config.cmd = {
		--
		-- 				-- 💀
		"java", -- or '/path/to/java17_or_newer/bin/java'
		-- depends on if `java` is in your $PATH env variable and if it points to the right version.

		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx8g",
		"-javaagent:" .. lombok_path,
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		-- 💀
		"-jar",
		path_to_jar,
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
		-- Must point to the                                                     Change this to
		-- eclipse.jdt.ls installation                                           the actual version

		-- 💀
		"-configuration",
		path_to_config,
		-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
		-- Must point to the                      Change to one of `linux`, `win` or `mac`
		-- eclipse.jdt.ls installation            Depending on your system.

		-- 💀
		-- See `data directory configuration` section in the README
		"-data",
		workspace_dir,
	}

	config.settings = {
		java = {
			references = {
				includeDecompiledSources = true,
			},
			format = {
				enabled = true,
				settings = {
					url = "home/sgarrett/.config/nvim/lang_servers/FormatEclipse.xml",
				},
			},
			eclipse = {
				downloadSources = true,
			},
			maven = {
				downloadSources = true,
			},
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			-- eclipse = {
			-- 	downloadSources = true,
			-- },
			-- implementationsCodeLens = {
			-- 	enabled = true,
			-- },
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
				importOrder = {
					"java",
					"javax",
					"com",
					"org",
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
					-- flags = {
					-- 	allow_incremental_sync = true,
					-- },
				},
				useBlocks = true,
			},
			-- configuration = {
			--     runtimes = {
			--         {
			--             name = "java-17-openjdk",
			--             path = "/usr/lib/jvm/default-runtime/bin/java"
			--         }
			--     }
			-- }
			-- project = {
			-- 	referencedLibraries = {
			-- 		"**/lib/*.jar",
			-- 	},
			-- },
		},
	}

	config.handlers = {
		["$/progress"] = function(_, result, ctx)
			-- disable progress updates.
		end,
	}

	config.on_attach = on_attach
	config.capabilities = capabilities
	--config.on_init = function(client, _)
	--	client.notify("workspace/didChangeConfiguration", { settings = config.settings })
	--end

	local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
	extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

	config.init_options = {
		bundles = bundles,
		extendedClientCapabilities = extendedClientCapabilities,
	}

	-- Start Server
	require("jdtls").start_or_attach(config)

	-- Set Java Specific Keymaps
	require("custom.lsp.jdtls.keymaps")
end

return M
