local fzf = require("fzf-lua")

fzf.setup()

vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "files" })
vim.keymap.set("n", "<leader>,", fzf.buffers, { desc = "buffers" })
vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "recent files" })
vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "goto defs" })
