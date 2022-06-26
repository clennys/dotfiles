-- LSP Setup
local cmd = vim.cmd

-- Install Servers
local lsp_installer = require("nvim-lsp-installer")
local servers = { "clangd", "bashls", "pyright", "sumneko_lua", "texlab", "tsserver", "ansiblels" }

for _, name in pairs(servers) do
	local server_is_found, server = lsp_installer.get_server(name)
	if server_is_found then
		if not server:is_installed() then
			print("Installing " .. name)
			server:install()
		end
	end
end

-- Configure lua language server for neovim development
local lua_settings = {
	Lua = {
		runtime = {
			-- LuaJIT in the case of Neovim
			version = "LuaJIT",
			path = vim.split(package.path, ";"),
		},
		diagnostics = {
			-- Get the language server to recognize the `vim` global
			globals = { "vim", "awesome", "client", "root", "use" },
		},
		workspace = {
			-- Make the server aware of Neovim runtime files
			library = {
				[vim.fn.expand("$VIMRUNTIME/lua")] = true,
				[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				['/usr/share/awesome/lib'] = true
			},
		},
	},
}
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	-- Mappings.
	local opts = { noremap = true, silent = true }

	buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	buf_set_keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	buf_set_keymap("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "<leader>of", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	buf_set_keymap("n", "[u", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]u", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	buf_set_keymap("n", "gpd", "<cmd> lua require('goto-preview').goto_preview_definition()<CR>", opts)
	buf_set_keymap("n", "gpi", "<cmd> lua require('goto-preview').goto_preview_implementation()<CR>", opts)
	buf_set_keymap("n", "gP", "<cmd> lua require('goto-preview').close_all_win()<CR>", opts)
	buf_set_keymap("n", "gpr", "<cmd> lua require('goto-preview').goto_preview_references()<CR>", opts)
end

-- config that activates keymaps and enables snippet support
local function make_config()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
	return {
		-- enable snippet support
		capabilities = capabilities,
		-- map buffer local keybindings when the language server attaches
		on_attach = on_attach,
	}
end

-- lsp-install
lsp_installer.on_server_ready(function(server)
	local config = make_config()
	if server.name == "sumneko_lua" then
		config.settings = lua_settings
	end
	server:setup(config)
end)

-- Design
cmd("sign define DiagnosticSignError text= texthl=DiagnosticSignError linehl= numhl=")
cmd("sign define DiagnosticSignWarn text=! texthl=DiagnosticSignWarn linehl= numhl=")
cmd("sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl=")
cmd("sign define DiagnosticSignHint text= texthl=DiagnosticSignHint linehl= numhl=")

-- Autocommand
vim.cmd([[
autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync(nil, 10000)
autocmd BufWritePre *.ts lua vim.lsp.buf.formatting_sync(nil, 10000)
autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 10000)
autocmd BufWritePre *.py.in lua vim.lsp.buf.formatting_sync(nil, 10000)
autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync(nil, 10000)
]])
