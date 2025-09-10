local function select_python_interpreter()
    local venv_python = vim.fn.getcwd() .. "/venv/bin/python"
    if vim.fn.filereadable(venv_python) == 1 then
        vim.g.python3_host_prog = venv_python
        vim.notify("Python interpreter set to: " .. venv_python, vim.log.levels.INFO)
    else
        vim.notify("No venv Python interpreter found", vim.log.levels.WARN)
    end
end

local map = vim.keymap.set
local telescope = require("telescope.builtin")
local dap = require("dap")
local nvim_tree = require("nvim-tree.api")

-- Navigation - Line movement
map("n", "<A-Down>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move line down" })
map("n", "<A-Up>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move line up" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection down" })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection up" })

-- Custom commands
map("n", "<leader>pi", select_python_interpreter, { desc = "Select Python Interpreter" })
map("n", "<D-CR>", "o<Esc>", { desc = "Insert empty line below (VSCode style)" })

-- General file operations
map("n", "<C-s>", ":w<CR>", { silent = true, desc = "Save file" })
-- map("n", "<C-w>", function() vim.cmd("bd") end, { desc = "Close buffer" })

-- Telescope (only if available)
if telescope then
    map("n", "<C-t>", telescope.find_files, { desc = "Find Files" })
    map("n", "<C-p>", telescope.live_grep, { desc = "Live grep" })
    map("n", "<C-r>", telescope.lsp_document_symbols, { desc = "Search symbol" })
    map("n", "<C-S-p>", telescope.commands, { desc = "Find commands" })
    map("n", "<leader>fb", telescope.buffers, { desc = "Find buffers" })
    map("n", "<leader>fh", telescope.help_tags, { desc = "Find help" })
    map("n", "<leader>fp", telescope.git_files, { desc = "Find Git files" })
    map("n", "<leader>fd", telescope.diagnostics, { desc = "Find diagnostics" })
    map("n", "<leader>fr", telescope.oldfiles, { desc = "Find recent files" })
    map("n", "<leader>fs", telescope.grep_string, { desc = "Find string under cursor" })
end

-- Yazi
map("n", "<leader>y", "<cmd>TermExec cmd='yazi' direction=float<CR>", { desc = "Open Yazi file manager" })

-- Debugger (only if DAP is available)
if dap then
    map("n", "<F5>", function() dap.continue() end, { desc = "DAP Continue" })
    map("n", "<F10>", function() dap.step_over() end, { desc = "DAP Step Over" })
    map("n", "<F11>", function() dap.step_into() end, { desc = "DAP Step Into" })
    map("n", "<F12>", function() dap.step_out() end, { desc = "DAP Step Out" })
    map("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "DAP Toggle Breakpoint" })
    map("n", "<leader>dr", function() dap.repl.open() end, { desc = "DAP REPL" })
    map("n", "<leader>dc", function() dap.clear_breakpoints() end, { desc = "DAP Clear Breakpoints" })
    map("n", "<leader>dt", function() dap.terminate() end, { desc = "DAP Terminate" })
end

-- NvimTree (only if available)
if nvim_tree then
    map("n", "<C-b>", function() nvim_tree.tree.toggle() end, { desc = "Toggle file tree" })
    map("n", "<leader>tr", function() nvim_tree.tree.reload() end, { desc = "Reload file tree" })
    map("n", "<leader>tc", function() nvim_tree.tree.collapse_all() end, { desc = "Collapse all tree nodes" })
end

-- Command line completion control
map("c", "<C-i>", "<C-d>", { desc = "Show command completions" })
map("c", "<C-n>", "<Down>", { desc = "Next completion" })
map("c", "<C-p>", "<Up>", { desc = "Previous completion" })

-- Enhanced command line navigation
map("c", "<C-a>", "<Home>", { desc = "Beginning of line" })
map("c", "<C-e>", "<End>", { desc = "End of line" })
map("c", "<C-f>", "<Right>", { desc = "Forward char" })
map("c", "<C-b>", "<Left>", { desc = "Backward char" })

map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
map("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Git commit" })
map("n", "<leader>gp", "<cmd>Git push<CR>", { desc = "Git push" })
map("n", "<leader>gP", "<cmd>Git pull<CR>", { desc = "Git pull" })
map("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })
map("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Git diff" })
