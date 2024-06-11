local jdtls = require("jdtls")
local root_markers = { "gradlew", ".javaroot" }

-- Setting Home Based off of rootmarker
local root_dir = require('jdtls.setup').find_root(root_markers)
--local current_file = vim.fn.expand("%:p")
--root_dir = vim.fn.fnamemodify(current_file, ":h")

local java_home = os.getenv("JAVA_HOME")
local home = os.getenv("HOME")
if not root_dir then
	print("Unable to determine project root.")
	return
end

local workspace_folder = vim.fn.stdpath("cache") .. "/nvim-jdtls" .. "/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

--Set Lombok.jar File Location
--local java_agent = vim.fn.glob("/usr/lib/lombok-common/lombok.jar")
local java_agent = os.getenv("HOME") .. "/.local/lib/lombok.jar"

jdtls.jol_path = os.getenv("HOME") .. "/apps/jol.jar"
local config = {

	root_dir = root_dir,

	java = {
		--format = {
		--settings = {
		--url = '/home/sheep/.config/nvim/plugin/Formates/intellij-java-google-style.xml'
		--}
		--},
		signatureHelp = { enabled = true },
		contentProvider = { preferred = "fernflower" },
		completion = {
			favoriteStaticMembers = {
				"io.crate.testing.Asserts.assertThat",
				"org.assertj.core.api.Assertions.assertThat",
				"org.assertj.core.api.Assertions.assertThatThrownBy",
				"org.assertj.core.api.Assertions.assertThatExceptionOfType",
				"org.assertj.core.api.Assertions.catchThrowable",
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
			},
			hashCodeEquals = {
				useJava7Objects = true,
			},
			useBlocks = true,
		},


        -- Configure for your Java Environment
		configuration = {
			updateBuildConfiguration = "interactive",
			runtimes = {
				{
					name = "JavaSE-17",
					path = vim.fn.expand("/usr/lib/jvm/java-17-openjdk"),
				},
			},
		},
	},
}
config.cmd = {
	java_home .. vim.fn.glob("/bin/java"),
	"-Declipse.application=org.eclipse.jdt.ls.core.id1",
	"-Dosgi.bundles.defaultStartLevel=4",
	"-Declipse.product=org.eclipse.jdt.ls.core.product",
	"-Dlog.protocol=true",
	"-Dlog.level=ALL",
	"-javaagent:" .. java_agent,
	"-Xmx4g",
	"--add-modules=ALL-SYSTEM",
	"--add-opens",
	"java.base/java.util=ALL-UNNAMED",
	"--add-opens",
	"java.base/java.lang=ALL-UNNAMED",
	"-jar",

    -- Change dev to be change able like in jdtls script
	vim.fn.glob(
		home
			.. "/dev/eclipse/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_*.jar"
	),
	"-configuration",
	home .. "/dev/eclipse/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux",
	"-data",
	workspace_folder,
}

config.on_attach = function(client, bufnr)
	local function with_compile(fn)
		return function()
			if vim.bo.modified then
				vim.cmd("w")
			end
			client.request_sync("java/buildWorkspace", false, 5000, bufnr)
			fn()
		end
	end

	local opts = { silent = true, buffer = bufnr }
	local set = vim.keymap.set
	require("jdtls.dap").setup_dap_main_class_configs()

	set("n", "<leader>df", "<cmd>lua require('jdtls').test_class()<cr>", opts)
	set("n", "<leader>dn", "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts)

	set("n", "<leader>df", jdtls.test_class, opts)
	set("n", "<leader>dn", jdtls.test_nearest_method, opts)
	set("n", "<A-o>", "<cmd>lua require('jdtls').organize_imports()<cr>", opts)
	set("n", "crv", "<cmd>lua require('jdtls').extract_variable()<cr>", opts)
	set("x", "crv", "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts)
	set("n", "crc", "<cmd>lua require('jdtls').extract_constant()<cr>", opts)
	set("x", "crc", "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts)
	set("x", "crm", "<esc><Cmd>lua require('jdtls').extract_method(true)<cr>", opts)
end

-- Change dev to be changable like in jdtls script
local jar_patterns = {
	home .. "/dev/microsoft/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
	home .. "/dev/dgileadi/vscode-java-decompiler/server/*.jar",
	home .. "/dev/microsoft/vscode-java-test/java-extension/com.microsoft.java.test.plugin/target/*.jar",
	home .. "/dev/microsoft/vscode-java-test/java-extension/com.microsoft.java.test.runner/target/*.jar",
	home .. "/dev/microsoft/vscode-java-test/java-extension/com.microsoft.java.test.runner/lib/*.jar",
}
-- npm install broke for me: https://github.com/npm/cli/issues/2508
-- So gather the required jars manually; this is based on the gulpfile.js in the vscode-java-test repo
local plugin_path = home
	.. "/dev/microsoft/vscode-java-test/java-extension/com.microsoft.java.test.plugin.site/target/repository/plugins/"

--local bundle_list = vim.tbl_map(function(x)
--return require("jdtls.path").join(plugin_path, x)
--end, {
--"org.eclipse.jdt.junit4.runtime_*.jar",
--"org.eclipse.jdt.junit5.runtime_*.jar",
--"org.junit.jupiter.api*.jar",
--"org.junit.jupiter.engine*.jar",
--"org.junit.jupiter.migrationsupport*.jar",
--"org.junit.jupiter.params*.jar",
--"org.junit.vintage.engine*.jar",
--"org.opentest4j*.jar",
--"org.junit.platform.commons*.jar",
--"org.junit.platform.engine*.jar",
--"org.junit.platform.launcher*.jar",
--"org.junit.platform.runner*.jar",
--"org.junit.platform.suite.api*.jar",
--"org.apiguardian*.jar",
--})
--vim.list_extend(jar_patterns, bundle_list)

-- Change dev
local bundles = {
	vim.fn.glob(
		home .. "/dev/microsoft/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
		1
	),
}

-- Use Lua's filesystem library to iterate over files in the directory
for file in io.popen("ls /dev/microsoft/vscode-java-test/server/*.jar"):lines() do
	-- Check if the filename does not end with the specified strings
	if
		not string.match(file, "com%.microsoft%.java%.test%.runner%-jar%-with%-dependencies%.jar$")
		and not string.match(file, "com%.microsoft%.java%.test%.runner%.jar$")
	then
		table.insert(bundles, file) -- Insert the bundle into the table
	end
end

-- Now 'bundles' table contains the filtered list of JAR files
-- You can iterate over 'bundles' and perform further operations if needed
--for _, bundle in ipairs(bundles) do
	--print(bundle)
--end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
--config.init_options = {

config["init_options"] = {
	extendedClientCapabilities = extendedClientCapabilities,
	bundles = bundles,
}
--config.handlers['language/status'] = function() end
jdtls.start_or_attach(config)
