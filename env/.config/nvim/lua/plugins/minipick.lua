local pick = require("mini.pick")

pick.setup()
vim.ui.select = pick.ui_select

vim.api.nvim_set_hl(0, "MiniPickBufferBar", { fg = "#6a9955", bg = "NONE", bold = true })

local function mru_buffer_items()
	local cur = vim.api.nvim_get_current_buf()
	local bufs = vim.fn.getbufinfo({ buflisted = 1 })
	local items = {}
	local current_item = nil
	for _, b in ipairs(bufs) do
		if b.name ~= "" then
			local bt = vim.bo[b.bufnr].buftype
			if bt == "" then
				local rel = vim.fn.fnamemodify(b.name, ":.")
				local item = {
					text = rel,
					bufnr = b.bufnr,
					_is_buffer = true,
					_abspath = b.name,
				}
				if b.bufnr == cur then
					current_item = item
				else
					table.insert(items, item)
				end
			end
		end
	end
	table.sort(items, function(a, b)
		local ai = vim.fn.getbufinfo(a.bufnr)[1]
		local bi = vim.fn.getbufinfo(b.bufnr)[1]
		return ai.lastused > bi.lastused
	end)
	if current_item then
		table.insert(items, current_item)
	end
	return items
end

local function project_recent_files()
	local cwd = vim.fn.getcwd()
	local git_root = vim.fn.system("git -C " .. cwd .. " rev-parse --show-toplevel 2>/dev/null"):gsub("%s+$", "")
	if git_root == "" then
		git_root = cwd
	end

	local project_files = {}
	for _, file in ipairs(vim.v.oldfiles) do
		if file:find(git_root, 1, true) == 1 then
			local rel_path = file:sub(#git_root + 2)
			table.insert(project_files, {
				text = rel_path,
				path = file,
			})
		end
	end
	return project_files
end

local function combined_mru_items()
	local items = {}
	local open_paths = {}

	local buffers = mru_buffer_items()
	for _, b in ipairs(buffers) do
		table.insert(items, b)
		open_paths[b._abspath] = true
	end

	local recent = project_recent_files()
	for _, r in ipairs(recent) do
		if not open_paths[r.path] then
			table.insert(items, r)
		end
	end

	return items
end

local ns = vim.api.nvim_create_namespace("minipick_buffer_bar")

local function show_with_buffer_bar(buf_id, items, query)
	pick.default_show(buf_id, items, query)
	vim.api.nvim_buf_clear_namespace(buf_id, ns, 0, -1)
	for i, item in ipairs(items) do
		if item._is_buffer then
			vim.api.nvim_buf_set_extmark(buf_id, ns, i - 1, 0, {
				virt_text = { { "▎", "MiniPickBufferBar" } },
				virt_text_pos = "inline",
				priority = 300,
			})
		end
	end
end

vim.keymap.set("n", "<leader><leader>", function()
	pick.start({
		source = {
			name = "Buffers + Recent",
			items = combined_mru_items(),
			show = show_with_buffer_bar,
		},
		})
end, { desc = "Buffers + Recent" })

vim.keymap.set("n", "<leader>ff", function()
	pick.builtin.files()
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>tt", function()
	pick.builtin.files()
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>fr", function()
	pick.start({
		source = {
			items = project_recent_files(),
			name = "Recent files",
		},
	})
end, { desc = "Recent files" })

vim.keymap.set("n", "<leader>tr", function()
	pick.start({
		source = {
			items = project_recent_files(),
			name = "Recent files",
		},
	})
end, { desc = "Recent files" })

vim.keymap.set("n", "<leader>fs", function()
	pick.builtin.grep_live()
end, { desc = "Live grep" })

vim.keymap.set("n", "<leader>ts", function()
	pick.builtin.grep_live()
end, { desc = "Live grep" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })