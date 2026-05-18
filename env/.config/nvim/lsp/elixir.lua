return {
	-- cmd = { "/home/robbo/elixir-ls/release/language_server.sh" },
	-- cmd = { "/home/robbo/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
	-- filetypes = { "elixir", "eelixir", "heex", "surface" },
	-- root_dir = function(bufnr, on_dir)
	-- 	local fname = vim.api.nvim_buf_get_name(bufnr)
	-- 	local matches = vim.fs.find({ "mix.exs" }, { upward = true, limit = 2, path = fname })
	-- 	local child_or_root_path, maybe_umbrella_path = unpack(matches)
	-- 	local root_dir = vim.fs.dirname(maybe_umbrella_path or child_or_root_path)
	--
	-- 	on_dir(root_dir)
	-- end,

	cmd = { "/home/robbo/expert/apps/expert/burrito_out/expert_linux_amd64", "--stdio" },
	root_markers = { "mix.exs", ".git" },
	filetypes = { "elixir", "eelixir", "heex" },
}
