local terminal = require("utils.terminal-output")

vim.keymap.set("n", "<leader>e", function()
	local file = vim.fn.expand("%")
	terminal("dotnet test", { filetype = "dotnet-output", rerun = "dotnet test" }, file)
end, { desc = "Run dotnet test" })

vim.keymap.set("n", "<leader>b", function()
	local file = vim.fn.expand("%")
	terminal("dotnet build", { filetype = "dotnet-output", rerun = "dotnet build" }, file)
end, { desc = "Run dotnet build" })