local pick = require("mini.pick")

pick.setup()
vim.ui.select = pick.ui_select



vim.keymap.set("n", "<leader><leader>", function()
	pick.builtin.buffers()
end, { desc = "Buffers" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })

local function get_project_recent_files()
	local cwd = vim.fn.getcwd()
	local git_root = vim.fn.system("git -C " .. cwd .. " rev-parse --show-toplevel 2>/dev/null"):gsub("%s+$", "")
	if git_root == "" then
		git_root = cwd
	end
	
	local project_files = {}
	for _, file in ipairs(vim.v.oldfiles) do
		if file:find(git_root, 1, true) == 1 then
			local rel_path = file:sub(#git_root + 2) -- +2 removes leading slash
			table.insert(project_files, rel_path)
		end
	end
	return project_files
end

vim.keymap.set("n", "<leader>fr", function()
	pick.start({
		source = {
			items = get_project_recent_files(),
			name = "Recent files",
		},
	})
end, { desc = "Recent files" })

vim.keymap.set("n", "<leader>tr", function()
	pick.start({
		source = {
			items = get_project_recent_files(),
			name = "Recent files",
		},
	})
end, { desc = "Recent files" })
