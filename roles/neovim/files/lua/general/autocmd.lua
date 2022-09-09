local autocmd = vim.api.nvim_create_autocmd
-- local augroup = vim.api.nvim_create_autogroup

autocmd("FileType", {
	pattern = { "markdown", "tex" },
	command = "set wrap "
})

autocmd("FileType", {
	pattern = { "markdown", "tex" },
	command = "set linebreak"
})

autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format()
	end,
	pattern = { "*.js", "*.ts", "*.py", "*.py.in", "*.lua" }
})

autocmd("TextYankPost",
	{
		callback = function()
			vim.highlight.on_yank()
		end
	})
