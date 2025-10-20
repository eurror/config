return {
  {
    "nvim-mini/mini.map",
    event = "VeryLazy",
    config = function()
      local map = require("mini.map")

      map.setup({
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.diagnostic(),
          map.gen_integration.gitsigns(),
        },
        symbols = {
          encode = map.gen_encode_symbols.dot("4x2"),
        },
        window = {
          side = "right",
          width = 10,
          show_integration_count = false,
        },
      })

      vim.keymap.set("n", "<leader>mm", map.toggle, { desc = "Toggle minimap" })
      vim.keymap.set("n", "<leader>mo", map.open, { desc = "Open minimap" })
      vim.keymap.set("n", "<leader>mc", map.close, { desc = "Close minimap" })
      vim.keymap.set("n", "<leader>mf", map.refresh, { desc = "Refresh minimap" })
    end,
  },
}

