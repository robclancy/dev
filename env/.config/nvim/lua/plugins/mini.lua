require("mini.completion").setup()
require("mini.comment").setup()

vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		if vim.bo.buftype == "prompt" then
			vim.b.minicompletion_disable = true
		end
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		if vim.bo[bufnr].buftype == "prompt" then
			vim.lsp.buf_detach_client(bufnr, args.data.client_id)
		end
	end,
})
