return {
  'princejoogie/chafa.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'm00qek/baleia.nvim',
  },
  keys = {
    { '<leader>v', '<cmd>ViewImage<cr>', desc = 'Toggle Image Preview' },
  },
  config = function()
    local baleia = require('baleia').setup({
      line_starts_at = 1,
    })

    -- Define explicit background colors for the floating window
    vim.api.nvim_set_hl(0, 'ViewImageBgBlack', { bg = '#000000', fg = '#ffffff' })
    vim.api.nvim_set_hl(0, 'ViewImageBgWhite', { bg = '#ffffff', fg = '#000000' })

    local active_win = nil
    local active_buf = nil
    local current_bg = 'black'

    vim.api.nvim_create_user_command('ViewImage', function()
      -- Toggle off logic
      if active_win and vim.api.nvim_win_is_valid(active_win) then
        vim.api.nvim_win_close(active_win, true)
        if active_buf and vim.api.nvim_buf_is_valid(active_buf) then
          vim.api.nvim_buf_delete(active_buf, { force = true })
        end
        active_win = nil
        active_buf = nil
        return
      end

      current_bg = 'black'

      local filepath = vim.fn.expand('%:p')
      if filepath == '' then
        vim.notify('No file active', vim.log.levels.ERROR)
        return
      end

      local ext = vim.fn.fnamemodify(filepath, ':e'):lower()
      local is_react = (ext == 'jsx' or ext == 'tsx' or ext == 'js' or ext == 'ts')
      local valid_extensions = { svg = true, png = true, jpg = true, jpeg = true, webp = true }

      local base_cmd = ''
      local stdin_data = nil

      if is_react then
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local content = table.concat(lines, '\n')
        local svg_content = content:match('(<svg.-</svg>)')

        if svg_content then
          svg_content = svg_content:gsub('fill={[^}]+}', 'fill="currentColor"')
          svg_content = svg_content:gsub('stroke={[^}]+}', 'stroke="currentColor"')

          stdin_data = svg_content
          base_cmd = 'chafa --colors truecolor --align center'
        else
          vim.notify('No embedded <svg> block discovered in this component.', vim.log.levels.WARN)
          return
        end
      elseif valid_extensions[ext] then
        base_cmd = 'chafa --colors truecolor --align center ' .. vim.fn.shellescape(filepath)
      else
        vim.notify('Unsupported media type: ViewImage only displays image assets.', vim.log.levels.WARN)
        return
      end

      -- Viewport dimensions calculation
      local screen_width = vim.o.columns
      local screen_height = vim.o.lines
      local float_width = math.floor(screen_width * 0.8)
      local float_height = math.floor(screen_height * 0.8)

      local col = math.floor((screen_width - float_width) / 2)
      local row = math.floor((screen_height - float_height) / 2)

      local buf_name = filepath .. ' (Preview)'
      local existing_buf = vim.fn.bufnr(buf_name)
      if existing_buf ~= -1 then
        vim.fn.execute('bwipeout! ' .. existing_buf)
      end

      active_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_name(active_buf, buf_name)
      vim.api.nvim_set_option_value('filetype', 'chafa', { buf = active_buf })

      local win_opts = {
        relative = 'editor',
        width = float_width,
        height = float_height,
        col = col,
        row = row,
        style = 'minimal',
        border = 'rounded',
      }
      active_win = vim.api.nvim_open_win(active_buf, true, win_opts)

      vim.keymap.set('n', 'q', function()
        if active_win and vim.api.nvim_win_is_valid(active_win) then
          vim.api.nvim_win_close(active_win, true)
        end
        if active_buf and vim.api.nvim_buf_is_valid(active_buf) then
          vim.api.nvim_buf_delete(active_buf, { force = true })
        end
        active_win = nil
        active_buf = nil
      end, { buffer = active_buf, silent = true, nowait = true })

      local max_cols = math.max(10, float_width - 4)
      local max_rows = math.max(5, float_height - 2)

      -- Isolated Render Engine
      local function render()
        -- 1. Apply matching background highlights to the floating window
        if active_win and vim.api.nvim_win_is_valid(active_win) then
          local hl_group = current_bg == 'white' and 'ViewImageBgWhite' or 'ViewImageBgBlack'
          vim.wo[active_win].winhighlight = 'Normal:' .. hl_group .. ',FloatBorder:' .. hl_group
        end

        -- 2. Construct chafa command with background flag for blending calculation
        local cmd = string.format('%s --bg %s --size %dx%d', base_cmd, current_bg, max_cols, max_rows)
        if is_react then
          cmd = cmd .. ' -'
        end

        local output = vim.fn.systemlist(cmd, stdin_data)

        local function get_visual_width(line)
          local clean = line:gsub('\27%[[%d;]*%a', ''):gsub('%[%?%d+[hl]', '')
          return vim.fn.strdisplaywidth(clean)
        end

        local raw_cleaned = {}
        local max_visual_width = 0
        for _, line in ipairs(output) do
          local cleaned = line:gsub('\27%[%?%d+[hl]', ''):gsub('%[%?%d+[hl]', '')
          table.insert(raw_cleaned, cleaned)

          local visual_len = get_visual_width(cleaned)
          if visual_len > max_visual_width then
            max_visual_width = visual_len
          end
        end

        local final_lines = {}
        local actual_height = #raw_cleaned

        local top_padding = math.max(0, math.floor((float_height - actual_height) / 2))
        for _ = 1, top_padding do
          table.insert(final_lines, '')
        end

        local left_padding_amt = math.max(0, math.floor((float_width - max_visual_width) / 2))
        local left_space = string.rep(' ', left_padding_amt)

        for _, line in ipairs(raw_cleaned) do
          table.insert(final_lines, left_space .. line)
        end

        local bottom_padding = float_height - #final_lines
        for _ = 1, bottom_padding do
          table.insert(final_lines, '')
        end

        vim.api.nvim_buf_set_lines(active_buf, 0, -1, false, final_lines)
        baleia.once(active_buf)
      end

      -- Run initial black render
      render()

      -- Keymaps
      vim.keymap.set('n', 'w', function()
        current_bg = 'white'
        render()
      end, { buffer = active_buf, silent = true, nowait = true })

      vim.keymap.set('n', 'b', function()
        current_bg = 'black'
        render()
      end, { buffer = active_buf, silent = true, nowait = true })
    end, {})
  end,
}
