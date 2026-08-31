return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    indent = {
      char = "▏",
      highlight = { "IblIndent" },
    },
    scope = {
      enabled = true,
      char = "▏",
      highlight = { "IblScope" },
    },
  },
  config = function(_, opts)
    local function set_indent_hl()
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#5f5f5f" })
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("IblIndentHighlight", { clear = true }),
      callback = set_indent_hl,
    })

    set_indent_hl()
    require("ibl").setup(opts)
  end,
}
