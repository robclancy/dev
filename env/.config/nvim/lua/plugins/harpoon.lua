local harpoon = require("harpoon")

harpoon.setup()

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end, { desc = "harpoon add" })

vim.keymap.set("n", "<leader>q", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "harpoon list" })

for _, idx in ipairs({ 1, 2, 3, 4, 5 }) do
	vim.keymap.set("n", string.format("<leader>%d", idx), function()
		harpoon:list():select(idx)
	end, { desc = "which_key_ignore" })
end
