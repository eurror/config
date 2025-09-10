{
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        dapui.setup()
        dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
        dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
        dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
},
{ "rcarriga/nvim-dap-ui", lazy = true, dependencies = { "nvim-neotest/nvim-nio" } },
{ "nvim-neotest/nvim-nio", lazy = true },
{
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
        local dap_python = require("dap-python")
        local venv_python = vim.fn.getcwd() .. "/venv/bin/python"
        if vim.fn.filereadable(venv_python) == 1 then
            dap_python.setup(venv_python)
        else
            dap_python.setup("python3")
        end
    end,
},
