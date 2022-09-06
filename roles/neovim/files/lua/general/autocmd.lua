local autocmd = vim.api.nvim_create_autocmd
-- local augroup = vim.api.nvim_create_autogroup

autocmd("BufWritePre", {
	-- callback = function()
	-- 	if client.supports_method("textDocument/formatting") then
	-- 		vim.lsp.buf.format()
	-- 	end
	-- end,
	command = vim.lsp.buf.format({ async = true }),
	pattern = { "*.js", "*.ts", "*.py", "*.py.in", "*.lua" }
})

autocmd("FileType", {
	pattern = { "markdown", "tex" },
	command = "setlocal wrap "
})

autocmd("FileType", {
	pattern = { "markdown", "tex" },
	command = "setlocal linebreak"
})
