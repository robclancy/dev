local function create_terminal_output_buffer(command, opts)
	opts = opts or {}

	vim.cmd("new")
	vim.cmd("terminal " .. command)

	vim.wo.number = opts.number or false
	vim.wo.relativenumber = opts.relativenumber or false
	vim.wo.signcolumn = opts.signcolumn or "no"
	vim.bo.filetype = opts.filetype or "terminal-output"

	vim.cmd("stopinsert")

	vim.keymap.set("n", "q", ":q<CR>", { buffer = true })
end

return create_terminal_output_buffer
