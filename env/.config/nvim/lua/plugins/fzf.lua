local fzf = require("fzf-lua")

fzf.setup()

vim.keymap.set("n", "<leader>pf", fzf.files, { desc = "files" })
vim.keymap.set("n", "<leader>pg", fzf.git_files, { desc = "git files" })
vim.keymap.set("n", "<leader>,", fzf.buffers, { desc = "buffers" })
vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "recent files" })

vim.keymap.set("n", "<leader>sp", fzf.live_grep, { desc = "grep files" })

vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "goto defs" })

-- my old binds
vim.keymap.set("n", "<leader>ff", '<cmd>echo "Use pg or pf"<CR>')
vim.keymap.set("n", "<leader><leader>", '<cmd>echo "Use ,"<CR>')
vim.keymap.set("n", "<leader>fg", '<cmd>echo "Use sp"<CR>')
