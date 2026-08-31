return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    columns = {
      "icon",
    },
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-s>"] = "actions.select_vsplit",
      ["<C-h>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<C-l>"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
    },
  },
  config = function(_, opts)
    require("oil").setup(opts)

    local function get_root()
      local status, project = pcall(require, "project_nvim.project")
      if status then
        return project.get_visual_configs() or project.find_pattern_root() or vim.fn.getcwd()
      end
      return vim.fn.getcwd()
    end

    vim.keymap.set("n", "<leader>pf", function()
      if vim.bo.filetype == "oil" then
        require("oil").parent()
      else
        local current = vim.api.nvim_buf_get_name(0)
        if current == "" or current:match("^oil://") then
          require("oil").open(get_root())
        else
          require("oil").open()
        end
      end
    end, { desc = "Open oil" })
  end,
}
