return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "Trouble",
  opts = {},
  init = function()
    vim.api.nvim_set_hl(0, "TroublePos", { fg = "#7aa2f7", bold = true })
    vim.api.nvim_set_hl(0, "TroubleSource", { fg = "#565f89", italic = true })
  end,
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle focus=true<cr>",
      desc = "Openning buffers Diagnostics",
    },
    {
      "<leader>q",
      "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>",
      desc = "Current Buffer Diagnostics",
    },
  },
}
