return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      cpp = { 'clang-format' },
      python = { 'black' },
      sh = { 'shfmt' },
      javascript = { 'prettierd', 'eslint_d', stop_after_first = false },
      typescript = { 'prettierd', 'eslint_d', stop_after_first = false },
      javascriptreact = { 'prettierd', 'eslint_d', stop_after_first = false },
      typescriptreact = { 'prettierd', 'eslint_d', stop_after_first = false },
      css = { 'prettierd' },
      html = { 'prettierd' },
    },
    format_on_save = {
      timeout_ms = 3000,
      lsp_fallback = true,
    },
  },
  config = function(_, opts)
    require('conform').setup(opts)

    vim.api.nvim_create_autocmd('User', {
      pattern = 'ConformFormatPost',
      callback = function(event)
        local bufnr = event.buf
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.api.nvim_buf_call(bufnr, function()
            pcall(vim.cmd, 'silent! GuessIndent')
          end)
        end
      end,
    })
  end,
}
