return {
  'folke/ts-comments.nvim',
  opts = {
    lang = {
      tsx = {
        '// %s',
        jsx_element = '{/* %s */}',
        jsx_fragment = '{/* %s */}',
        jsx_attribute = '// %s',
      },
      javascript = {
        '// %s',
        jsx_element = '{/* %s */}',
        jsx_fragment = '{/* %s */}',
        jsx_attribute = '// %s',
      },
    },
  },
  config = function(_, opts)
    require('ts-comments').setup(opts)

    -- Neovim 0.12's native `gc` reads the buffer-local commentstring
    -- directly. Keep it synchronized with the comment style resolved from
    -- the Treesitter node under the cursor.
    local group = vim.api.nvim_create_augroup('TSContextCommentstring', { clear = true })

    local function update_commentstring(args)
      if not vim.tbl_contains({ 'javascriptreact', 'typescriptreact' }, vim.bo[args.buf].filetype) then
        return
      end

      pcall(function()
        vim.treesitter.get_parser(args.buf):parse()
        vim.bo[args.buf].commentstring = require('ts-comments.comments').get(vim.bo[args.buf].filetype)
      end)
    end

    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorMoved' }, {
      group = group,
      pattern = { '*.jsx', '*.tsx' },
      callback = update_commentstring,
    })

    update_commentstring({ buf = vim.api.nvim_get_current_buf() })
  end,
  event = 'VeryLazy',
  enabled = true,
}
