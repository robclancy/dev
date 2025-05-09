local harpoon = require("harpoon")

harpoon.setup()

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end, { desc = "harpoon add" })

vim.keymap.set("n", "<leader>`", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "harpoon list" })

vim.keymap.set("n", "<leader>h", function()
	harpoon:list():select(1)
end)

vim.keymap.set("n", "<leader>j", function()
	harpoon:list():select(2)
end)

vim.keymap.set("n", "<leader>k", function()
	harpoon:list():select(3)
end)

vim.keymap.set("n", "<leader>l", function()
	harpoon:list():select(4)
end)

-- for _, idx in ipairs({ 1, 2, 3, 4, 5 }) do
-- 	vim.keymap.set("n", string.format("<leader>%d", idx), function()
-- 		harpoon:list():select(idx)
-- 	end, { desc = "which_key_ignore" })
-- end
