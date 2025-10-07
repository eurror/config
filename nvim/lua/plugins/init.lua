local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Собираем все модули из папки plugins
local plugins = {}
local plugin_files = {
	"plugins.neotree",
	"plugins.telescope",
	"plugins.treesitter",
	"plugins.lsp",
	"plugins.cmp",
	"plugins.vscode",
	"plugins.lualine",
	"plugins.bufferline",
	"plugins.mew-yarn",
	-- "plugins.git",
	-- "plugins.files",
	-- "plugins.debug",
	-- "plugins.notifications",
	-- "plugins.ux",
	-- "plugins.disabled",
}

for _, file in ipairs(plugin_files) do
	local ok, mod = pcall(require, file)
	if ok and type(mod) == "table" then
		for _, plugin in ipairs(mod) do
			table.insert(plugins, plugin)
		end
	end
end

require("lazy").setup(plugins)
