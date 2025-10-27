-- https://www.reddit.com/r/neovim/comments/1nbiv93/combining_best_of_marks_and_harpoon_with_grapple/
local function save_mark()
	local char = vim.fn.getcharstr()
	-- Handle ESC, Ctrl-C, etc.
	if char == "" or vim.startswith(char, "<") then
		return
	end
	local grapple = require("grapple")
	grapple.tag({ name = char })
	local filepath = vim.api.nvim_buf_get_name(0)
	local filename = vim.fn.fnamemodify(filepath, ":t")
	vim.notify("Marked " .. filename .. " as " .. char)
end

local function open_mark()
	local char = vim.fn.getcharstr()
	-- Handle ESC, Ctrl-C, etc.
	if char == "" or vim.startswith(char, "<") then
		return
	end
	local grapple = require("grapple")
	if char == "'" then
		grapple.toggle_tags()
		return
	end
	grapple.select({ name = char })
end

vim.keymap.set("n", "m", save_mark, { noremap = true, silent = true })
vim.keymap.set("n", "'", open_mark, { noremap = true, silent = true })
