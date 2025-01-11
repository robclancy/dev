-- show full path with the last x as full path, this is meant to always be the only tab
-- so we have a lot of space we can use compared to the default path shortening
function LongerTabline()
	local last_x_full = 5

	-- this will show stuff like "oil", trying to handle special buffers basically
	local buf = vim.api.nvim_buf_get_option(0, "buftype")
	if not (buf == '') then
		return vim.bo.filetype
	end

	local path = vim.fn.expand('%:p:.')
	local parts = vim.split(path, '/')

	local out = {}
	for i, part in ipairs(parts) do
		if i <= #parts - last_x_full then
			out[i] = string.sub(part, 1, 1)
			if out[i] == '.' then
				out[i] = string.sub(part, 1, 2)
			end
		else
			out[i] = part
		end
	end

	return table.concat(out, '/')
end

vim.opt.tabline = '%{v:lua.LongerTabline()}'
