return {
  'saghen/blink.cmp',
  dependencies = {
    'rafamadriz/friendly-snippets',
  },
  version = 'v1.*',
  build = 'download',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    completion = {
      trigger = {
        prefetch_on_insert = true,
        show_on_insert_on_trigger_character = true,
      },
      menu = {
        auto_show = true,
        draw = {
          columns = {
            { 'label', 'label_description', gap = 1 },
            { 'kind_icon', 'kind', gap = 1 },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
      },
      list = {
        selection = { preselect = false, auto_insert = true },
      },
    },
    fuzzy = {
      sorts = { 'score', 'kind', 'label' },
    },
    keymap = {
      preset = 'default',
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-n>'] = {},
      ['<C-p>'] = {},
      ['<Tab>'] = { 'select_and_accept', 'fallback' },
      -- ["<CR>"] = { "select_and_accept", "fallback" },
      ['<Esc>'] = { 'hide', 'fallback' },
    },

    cmdline = {
      enabled = false,
    },
  },
}
