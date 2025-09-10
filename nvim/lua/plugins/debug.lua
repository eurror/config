return {
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        keys = {
            { "<F5>",       function() require("dap").continue() end,                                             desc = "DAP Continue" },
            { "<F10>",      function() require("dap").step_over() end,                                            desc = "DAP Step Over" },
            { "<F11>",      function() require("dap").step_into() end,                                            desc = "DAP Step Into" },
            { "<F12>",      function() require("dap").step_out() end,                                             desc = "DAP Step Out" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "DAP Toggle Breakpoint" },
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "DAP Conditional Breakpoint" },
            { "<leader>dr", function() require("dap").repl.open() end,                                            desc = "DAP REPL" },
            { "<leader>dc", function() require("dap").clear_breakpoints() end,                                    desc = "DAP Clear Breakpoints" },
            { "<leader>dt", function() require("dap").terminate() end,                                            desc = "DAP Terminate" },
        },
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                dependencies = { "nvim-neotest/nvim-nio" },
                config = function()
                    local dap, dapui = require("dap"), require("dapui")
                    dapui.setup()

                    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
                    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
                    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
                    dap.listeners.before.disconnect["dapui_config"] = function() dapui.close() end
                end,
            },
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {
                    commented = true,
                },
            },
        },
        config = function()
            vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointCondition",
            { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
            vim.fn.sign_define("DapLogPoint", { text = "▶", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
        end,
    },
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
}
