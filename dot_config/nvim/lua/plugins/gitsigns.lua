return {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup({
      signs = {
        add = { text = '│' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '│' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged_enable = true,
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 100,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      current_line_blame_formatter = '   <author>, <author_time:%Y-%m-%d %H:%M> - <summary>',
      blame_formatter = nil,
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = {
        style = 'minimal',
        relative = 'cursor',
        border = 'rounded',
        row = 0,
        col = 1,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', '<leader>gb', function()
          gs.blame_line({ preview = true })
        end, { desc = 'Git Blame' })
      end,
    })

    vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#50FA7B', bold = true })
    vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#8BE9FD' })
    vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = '#FF0000' })

    vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { fg = '#000000' })
  end,
}
