local nvim_func = {}
local b = vim.bo
local cmd = vim.cmd

function nvim_func.adjust_shiftwith(current_shiftwith, adjusted_shiftwith)
	b.ts = current_shiftwith
	b.sts = current_shiftwith
	cmd("set noet")
	cmd("retab!")
	b.ts = adjusted_shiftwith
	b.sts = adjusted_shiftwith
	cmd("set et")
	cmd("retab")
end

return nvim_func
