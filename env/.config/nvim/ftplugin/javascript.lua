local terminal = require("utils.terminal-output")

vim.treesitter.start()

vim.keymap.set("n", "<leader>e", function()
	terminal("pnpm jest " .. vim.fn.shellescape(vim.fn.expand("%")), {
		filetype = "jest-output",
	})
end, { desc = "Run Jest for current file" })
