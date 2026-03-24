vim.lsp.enable({
	"luals",
	"vtsls",
	"astro",
	"yamlls",
	"jsonls",
	"cssls",
	"html",
	-- "phan",
	"elixir",
	"phpactor",
	"odin",
})

-- https://github.com/neovim/neovim/issues/12970#issuecomment-1166957212
vim.lsp.util.apply_text_document_edit = function(text_document_edit, index, offset_encoding)
	local text_document = text_document_edit.textDocument
	local bufnr = vim.uri_to_bufnr(text_document.uri)
	if offset_encoding == nil then
		vim.notify_once("apply_text_document_edit must be called with valid offset encoding", vim.log.levels.WARN)
	end

	vim.lsp.util.apply_text_edits(text_document_edit.edits, bufnr, offset_encoding)
end

vim.lsp.config("*", {
	root_markers = { ".git", ".hg" },
	vim.lsp.config("*", {
		capabilities = {
			textDocument = {
				semanticTokens = {
					multilineTokenSupport = true,
				},
			},
		},
	}),
})

vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "goto type" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "goto ref" })

vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "rename" })
vim.keymap.set("n", "<leader>ca", function()
	vim.lsp.buf.code_action({
		filter = function(action)
			return not action.disabled
		end,
	})
end)

vim.keymap.set("n", "<leader>fu", "<cmd>LspRestart<CR>", { desc = "all my homies hate lsps" })

vim.api.nvim_create_user_command("LspRestart", function()
	local detach_clients = {}
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		client:stop(true)
		if vim.tbl_count(client.attached_buffers) > 0 then
			detach_clients[client.name] = { client, vim.lsp.get_buffers_by_client_id(client.id) }
		end
	end
	local timer = vim.uv.new_timer()
	if not timer then
		return vim.notify("Servers are stopped but havent been restarted")
	end
	timer:start(
		100,
		50,
		vim.schedule_wrap(function()
			for name, client in pairs(detach_clients) do
				local client_id = vim.lsp.start(client[1].config, { attach = false })
				if client_id then
					for _, buf in ipairs(client[2]) do
						vim.lsp.buf_attach_client(buf, client_id)
					end
					vim.notify(name .. ": restarted")
				end
				detach_clients[name] = nil
			end
			if next(detach_clients) == nil and not timer:is_closing() then
				timer:close()
			end
		end)
	)
end, {
	desc = "Restart all the language clients attached to the current buffer",
})
