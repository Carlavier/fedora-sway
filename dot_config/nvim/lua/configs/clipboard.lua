if vim.env.TMUX then
  vim.g.clipboard = {
    name = "smart-tmux-clipboard",
    copy = {
      ["+"] = function(lines, _)
        local text = table.concat(lines, "\n")
        if vim.env.SSH_CLIENT or vim.env.SSH_TTY then
          local b64 = vim.fn.system('base64 | tr -d "\n"', text)
          local tty = vim.fn.system('tmux display-message -p "#{client_tty}"'):gsub("%s+", "")
          if tty ~= "" then
            vim.fn.system(string.format('printf "\\033]52;c;%s\\007" > %s', b64, tty))
          end
        else
          vim.fn.system("wl-copy", text)
        end
      end,
    },
    paste = {
      ["+"] = function()
        return { vim.fn.getreg("+"), vim.fn.getregtype("+") }
      end,
    },
  }
  vim.g.clipboard.copy["*"] = vim.g.clipboard.copy["+"]
  vim.g.clipboard.paste["*"] = vim.g.clipboard.paste["+"]
end
