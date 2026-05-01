vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/echasnovski/mini.icons" },

	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/folke/lazydev.nvim" },
	{ src = "https://github.com/dmtrKovalenko/fff.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/zbirenbaum/copilot.lua" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/alexghergh/nvim-tmux-navigation" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/echasnovski/mini.completion" },
	{ src = "https://github.com/echasnovski/mini.comment" },
	{ src = "https://github.com/echasnovski/mini.animate" },
	{ src = "https://github.com/tpope/vim-rhubarb" },
	{ src = "https://github.com/vimwiki/vimwiki" },
	{ src = "https://github.com/cbochs/grapple.nvim" },

	{ src = "https://github.com/alligator/accent.vim" },
	{ src = "https://github.com/webhooked/kanso.nvim" },
	{ src = "https://github.com/scottmckendry/cyberdream.nvim" },
	{ src = "https://github.com/rostislavarts/naysayer.nvim" },
	{ src = "https://github.com/kungfusheep/mfd.nvim" },
	{ src = "https://github.com/smit4k/shale.nvim" },

	{ src = "https://github.com/numToStr/Comment.nvim" },

	{ src = "https://github.com/lewis6991/gitsigns.nvim" },

	{ src = "https://github.com/sudo-tee/opencode.nvim" },
	{ src = "https://github.com/kevinhwang91/nvim-bqf" },
})

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "fff.nvim" and (kind == "install" or kind == "update") then
			if not ev.data.active then
				vim.cmd.packadd("fff.nvim")
			end
			require("fff.download").ensure_downloaded()
		end
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		require("init")
	end,
	once = true,
})
