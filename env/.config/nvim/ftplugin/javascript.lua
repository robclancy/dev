local terminal = require("utils.terminal-output")

vim.keymap.set("n", "<leader>e", function()
	local current_file = vim.fn.expand("%")
	terminal("pnpm jest " .. vim.fn.shellescape(current_file), {
		filetype = "jest-output",
	}, current_file)
end, { desc = "Run Jest for current file" })
