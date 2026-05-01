vim.api.nvim_create_user_command("Transparent", function()
	vim.api.nvim_set_hl(0, "Normal", { bg = "None" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#111111" })
end, {})

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
	callback = function()
		io.stdout:write("\27]12;orange\7")
	end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "VimLeave" }, {
	callback = function()
		io.stdout:write("\27]12;white\7")
	end,
})

require("kanso").setup({
	undercurl = true,
	transparent = true,
	commentStyle = { italic = true },
	theme = "zen",
})

require("cyberdream").setup({
	transparent = true,
	-- saturation = 0.8,
	italic_comments = true,
	extensions = {
		blinkcmp = true,
		fzflua = true,
		treesitter = true,
	},
})

local function mfd()
	vim.cmd("colorscheme mfd-flir")

	vim.opt.guicursor = {
		"n:block-CursorNormal",
		"v:block-CursorVisual",
		"i:block-CursorInsert",
		"r-cr:block-CursorReplace",
		"c:block-CursorCommand",
	}

	require("mfd").enable_cursor_sync()
end

local themes = {
	"mfd-stealth",
	"mfd-amber",
	"mfd-mono",
	"mfd-hud",
	"mfd-nvg",
	"mfd-blackout",
	"mfd-flir",
	"mfd-flir-bh",
	"mfd-flir-rh",
	"mfd-flir-fusion",
	"mfd-gbl-light",
	"mfd-gbl-dark",
	"mfd-lumon",
	"naysayer",
	"matrix",
}

local current = 3 -- mfd-stealth
local function next_theme()
	current = (current % #themes) + 1
	vim.cmd("colorscheme " .. themes[current])
	vim.notify("Theme: " .. themes[current])
end

-- vim.keymap.set("n", "t", next_theme, { desc = "Next MFD theme" })
vim.api.nvim_create_user_command("MfdNextTheme", next_theme, { desc = "Next MFD theme" })

vim.cmd("colorscheme shale")

local bg = "#0a0a0a"

vim.api.nvim_set_hl(0, "Normal", { bg = bg })
vim.api.nvim_set_hl(0, "NormalNC", { bg = bg })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = bg })
vim.api.nvim_set_hl(0, "Pmenu", { bg = bg })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#1f1f1f" })
vim.api.nvim_set_hl(0, "PmenuSbar", { bg = bg })
vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#333333" })

-- mfd()

-- vim.cmd("colorscheme matrix")

-- vim.cmd("colorscheme kanso")
-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#080808" })

-- vim.cmd("colorscheme naysayer")
