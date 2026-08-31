return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      globalstatus = true,
    },
    config = function()
      local colors = {
        blue = "#0055ff",
        red = "#ff0000",
        yellow = "#ffff00",
        green = "#00ff00",
        orange = "#ff8800",
        black = "#000000",
        gray1 = "#444444",
        gray2 = "#1a1a1a",
        white = "#eeeeee",
        dim = "#666666",
      }

      local custom_theme = {
        normal = {
          a = { fg = colors.black, bg = colors.blue, gui = "bold" },
          b = { fg = colors.white, bg = colors.gray1 },
          c = { fg = colors.white, bg = colors.gray2 },
        },
        insert = { a = { fg = colors.black, bg = colors.red, gui = "bold" } },
        visual = { a = { fg = colors.black, bg = colors.yellow, gui = "bold" } },
        replace = { a = { fg = colors.black, bg = colors.green, gui = "bold" } },
        command = { a = { fg = colors.black, bg = colors.orange, gui = "bold" } },
        inactive = {
          a = { fg = colors.dim, bg = colors.black },
          b = { fg = colors.dim, bg = colors.black },
          c = { fg = colors.dim, bg = colors.black },
        },
      }

      local function update_cursor_line_hl()
        local mode = vim.api.nvim_get_mode().mode
        local bg_color = colors.blue

        if mode == "n" then
          bg_color = colors.blue
        elseif mode == "i" or mode == "ic" then
          bg_color = colors.red
        elseif mode:find("^[vV\22]") then
          bg_color = colors.yellow
        elseif mode == "R" then
          bg_color = colors.green
        elseif mode == "c" then
          bg_color = colors.orange
        end

        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.black, bg = bg_color, bold = true })
      end

      vim.api.nvim_create_autocmd({ "ModeChanged", "ColorScheme" }, {
        callback = update_cursor_line_hl,
      })

      vim.schedule(function()
        update_cursor_line_hl()
      end)

      require("lualine").setup({
        options = {
          theme = custom_theme,
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            {
              function()
                return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
              end,
              color = { fg = colors.orange, gui = "bold" },
              padding = { left = 1, right = 0 },
              separator = "",
            },
            {
              function()
                return " │ "
              end,
              color = { fg = colors.dim },
              padding = { left = 0, right = 0 },
              separator = "",
            },
            {
              "filename",
              path = 1,
              padding = { left = 0, right = 1 },
              separator = "",
            },
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
}
