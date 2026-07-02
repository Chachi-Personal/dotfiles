vim.pack.add({
	"https://github.com/mfussenegger/nvim-dap",

	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/theHamsta/nvim-dap-virtual-text",
})

local dap = require("dap")
local ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")

dap_virtual_text.setup()

local ok, reg = pcall(require, "mason-registry")
if ok then
	reg.refresh(function()
		for _, p in ipairs({ "cpptools", "debugpy" }) do
			local okp, pkg = pcall(reg.get_package, p)
			if okp and not pkg:is_installed() then
				pkg:install()
			end
		end
	end)
end

local cpptools_path = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7"
local debugpy_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/debugpy-adapter"

dap.adapters = {
	cppdbg = {
		type = "executable",
		id = "cppdbg",
		command = cpptools_path,
	},
	python = {
		type = "executable",
		command = debugpy_path,
	},
}

-- Configurations
dap.configurations = {
	c = {
		{
			name = "Launch file",
			type = "cppdbg",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopAtEntry = false,
			MIMode = "gdb",
			miDebuggerPath = "/usr/bin/gdb",
		},
		{
			name = "Attach to lldbserver :1234",
			type = "cppdbg",
			request = "launch",
			MIMode = "lldb",
			miDebuggerServerAddress = "localhost:1234",
			miDebuggerPath = "/usr/bin/lldb",
			cwd = "${workspaceFolder}",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
		},
	},
	python = {
		{
			-- The first three options are required by nvim-dap
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "Launch file",

			-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

			program = "${file}", -- This configuration will launch the current file if used.
			pythonPath = function()
				-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
				-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
				-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
				local cwd = vim.fn.getcwd()
				if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
					return cwd .. "/venv/bin/python"
				elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
					return cwd .. "/.venv/bin/python"
				else
					return "/usr/bin/python"
				end
			end,
		},
		{
			type = "python",
			request = "launch",
			name = "Launch (prompt args)",
			program = "${file}",
			args = function()
				return vim.fn.split(vim.fn.input("Args: "))
			end,
			pythonPath = function()
				-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
				-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
				-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
				local cwd = vim.fn.getcwd()
				if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
					return cwd .. "/venv/bin/python"
				elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
					return cwd .. "/.venv/bin/python"
				else
					return "/usr/bin/python"
				end
			end,
		},
	},
}

ui.setup()

vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

dap.listeners.before.attach.dapui_config = function()
	ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	ui.close()
end

local map = vim.keymap.set
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
map("n", "<leader>dc", dap.continue, { desc = "Continue" })
map("n", "<leader>di", dap.step_into, { desc = "Step Into" })
map("n", "<leader>do", dap.step_over, { desc = "Step Over" })
map("n", "<leader>du", dap.step_out, { desc = "Step Out" })
map("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
map("n", "<leader>d<CR>", dap.run_last, { desc = "Run Last" })
map("n", "<leader>dq", function()
	dap.terminate()
	ui.close()
	dap_virtual_text.toggle()
end, { desc = "Terminate" })
map("n", "<leader>dl", dap.list_breakpoints, { desc = "List Breakpoints" })
map("n", "<leader>de", function()
	dap.set_exception_breakpoints({ "all" })
end, { desc = "Set Excetion Breakpoints" })
