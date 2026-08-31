return {
  "VPavliashvili/json-nvim",
  config = function()
    vim.keymap.set("n", "<leader>fjf", "<cmd>JsonFormatFile<cr>", { desc = "Format Json File" })
    vim.keymap.set("n", "<leader>fjm", "<cmd>JsonMinifyFile<cr>", { desc = "Minify Json File" })
  end,
}
