local function sync_opencode_links()
  local mason_bin_dir = vim.fn.expand("~/.local/share/nvim/mason/bin")
  local target_dir = "/usr/local/bin"

  if vim.fn.isdirectory(mason_bin_dir) == 0 then
    vim.notify("Mason bin directory not found!", vim.log.levels.ERROR)
    return
  end

  local target_handle = vim.uv.fs_scandir(target_dir)
  if target_handle then
    while true do
      local name, type = vim.uv.fs_scandir_next(target_handle)
      if not name then
        break
      end

      if type == "link" then
        local target_path = target_dir .. "/" .. name
        local origin_path = vim.fn.resolve(target_path)

        if origin_path:find(mason_bin_dir, 1, true) and vim.fn.filereadable(origin_path) == 0 then
          vim.fn.system(string.format("sudo rm %s", target_path))
          vim.notify("Removed broken link: " .. name, vim.log.levels.WARN)
        end
      end
    end
  end

  local mason_handle = vim.uv.fs_scandir(mason_bin_dir)
  if not mason_handle then
    return
  end

  local count = 0
  while true do
    local name, type = vim.uv.fs_scandir_next(mason_handle)
    if not name then
      break
    end

    if type == "file" or type == "link" then
      local source_path = mason_bin_dir .. "/" .. name
      local target_path = target_dir .. "/" .. name

      if vim.fn.getftype(target_path) == "" then
        local cmd = string.format("sudo ln -s %s %s", source_path, target_path)
        vim.fn.system(cmd)
        count = count + 1
      end
    end
  end

  if count > 0 then
    vim.notify(string.format("Linked %d new LSPs to %s", count, target_dir), vim.log.levels.INFO)
  else
    vim.notify("LSP symlinks are fully synchronized.", vim.log.levels.INFO)
  end
end

vim.api.nvim_create_user_command("OpencodeLink", sync_opencode_links, {})
