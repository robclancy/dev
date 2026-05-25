local dap = require("dap")
local dapui = require("dapui")

dap.adapters.coreclr = {
	type = "executable",
	command = "netcoredbg",
	args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
	{
		type = "coreclr",
		name = "Attach to Godot",
		request = "attach",
		processId = function()
			local output = vim.fn.system("pgrep -f 'godot.*--debugger'") 
			if output == "" then
				output = vim.fn.system("pgrep -f '.dotnet/GodotSharp'")
			end
			if output == "" then
				vim.notify("No Godot process found. Start Godot with debugging first.", vim.log.levels.WARN)
				return nil
			end
			local pid = tonumber(output:match("(%d+)"))
			return pid
		end,
	},
	{
		type = "coreclr",
		name = "Launch - netcoredbg",
		request = "launch",
		program = function()
			return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
		end,
	},
}

dapui.setup()


dap.adapters.lldb = {
  type = "executable",
  command = "/usr/bin/lldb-dap",
  name = "lldb",
}

dap.configurations.rust = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.getcwd() .. "/target/debug/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "toggle breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "continue/start" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "step into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "step over" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "step out" })
vim.keymap.set("n", "<leader>dq", dap.close, { desc = "close debugger" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "toggle dap ui" })
