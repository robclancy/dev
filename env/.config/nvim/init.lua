vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/echasnovski/mini.icons" },

	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/folke/lazydev.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/zbirenbaum/copilot.lua" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/alexghergh/nvim-tmux-navigation" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/tpope/vim-rhubarb" },
	{ src = "https://github.com/vimwiki/vimwiki" },
	-- { src = "https://github.com/dmtrKovalenko/fff.nvim" },

	{ src = "https://github.com/alligator/accent.vim" },
	{ src = "https://github.com/webhooked/kanso.nvim" },
	{ src = "https://github.com/scottmckendry/cyberdream.nvim" },
	{ src = "https://github.com/rostislavarts/naysayer.nvim" },

	{ src = "https://github.com/numToStr/Comment.nvim" },
})

local cargo_plugins = {
	"blink.cmp",
	-- "fff.nvim",
}

local build_status = {}

local function build_cargo_plugin(plugin_name, callback)
	local pack_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/" .. plugin_name
	local plugin_path = vim.fn.glob(pack_path)

	if plugin_path == "" then
		vim.notify(plugin_name .. " not found in pack directory: " .. pack_path)
		build_status[plugin_name] = "not_found"
		if callback then
			callback(false)
		end

		return
	end

	local target_dir = plugin_path .. "/target/release"
	if vim.fn.isdirectory(target_dir) == 1 and #vim.fn.glob(target_dir .. "/*") > 0 then
		-- vim.notify(plugin_name .. " already built, skipping")
		build_status[plugin_name] = "success"
		if callback then
			callback(true)
		end

		return
	end

	build_status[plugin_name] = "building"
	local build_cmd = 'cd "' .. plugin_path .. '" && cargo build --release'
	vim.notify("Building " .. plugin_name .. "...")

	vim.fn.jobstart(build_cmd, {
		on_exit = function(_, exit_code)
			if exit_code == 0 then
				vim.notify(plugin_name .. " built successfully")
				vim.notify[plugin_name] = "success"
			else
				vim.notify("Build failed for " .. plugin_name)
				build_status[plugin_name] = "failed"
			end
			if callback then
				callback(exit_code == 0)
			end
		end,
		on_stderr = function(_, data)
			if data and #data > 0 then
				local stderr_text = table.concat(data, "\n")
				if stderr_text:match("error:") or stderr_text:match("failed") then
					vim.notify("Build error: " .. stderr_text)
				end
			end
		end,
	})
end

local function wait_for_build(plugin_name, callback, max_wait)
	max_wait = max_wait or 30000
	local start_time = vim.loop.now()

	local function check_build()
		local status = build_status[plugin_name]
		if status == "success" then
			callback(true)
		elseif status == "failed" or status == "not_found" then
			callback(false)
		elseif vim.loop.now() - start_time > max_wait then
			vim.notify("Timeout waiting for " .. plugin_name .. " build")
			callback(false)
		else
			vim.defer_fn(check_build, 100)
		end
	end

	check_build()
end

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function()
		for _, plugin in ipairs(cargo_plugins) do
			build_cargo_plugin(plugin)
		end
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		for _, plugin in ipairs(cargo_plugins) do
			build_cargo_plugin(plugin)
		end

		wait_for_build("blink.cmp", function(success)
			-- if success then
			-- 	vim.notify("blink.cmp ready, loading config...")
			-- else
			-- 	vim.notify("blink.cmp build failed, loading config anyway...")
			-- end
			require("init")
		end)
	end,
	once = true,
})
