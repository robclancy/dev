-- This is all AI, been done over time

local terminal_buffers = {}

local function create_terminal_output_buffer(command, opts, source_file)
	opts = opts or {}
	local buffer_key = opts.filetype or "terminal-output"

	local existing_buf = terminal_buffers[buffer_key]
	if existing_buf and vim.api.nvim_buf_is_valid(existing_buf) then
		local wins = vim.fn.win_findbuf(existing_buf)
		if #wins > 0 then
			vim.api.nvim_set_current_win(wins[1])
		else
			vim.cmd("new")
			vim.api.nvim_set_current_buf(existing_buf)
		end

		vim.bo.modifiable = true
		vim.api.nvim_buf_set_lines(existing_buf, 0, -1, false, {})
		vim.bo.modified = false
		vim.fn.termopen(command)
		vim.cmd("stopinsert")
		return
	end

	vim.cmd("new")
	vim.cmd("terminal " .. command)
	local buf = vim.api.nvim_get_current_buf()
	terminal_buffers[buffer_key] = buf

	vim.wo.number = opts.number or false
	vim.wo.relativenumber = opts.relativenumber or false
	vim.wo.signcolumn = opts.signcolumn or "no"
	vim.bo.filetype = opts.filetype or "terminal-output"

	vim.api.nvim_create_autocmd("BufDelete", {
		buffer = buf,
		callback = function()
			terminal_buffers[buffer_key] = nil
		end,
	})

	vim.keymap.set("n", "q", ":q<CR>", { buffer = true })
	vim.keymap.set("n", "<leader>e", function()
		vim.bo.modifiable = true
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
		vim.bo.modified = false
		vim.fn.termopen("pnpm jest " .. vim.fn.shellescape(source_file))
		vim.cmd("stopinsert")
	end, { buffer = true })

	vim.cmd("stopinsert")
end

return create_terminal_output_buffer
