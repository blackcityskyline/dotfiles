-- simple-transparent.lua - супер легкий вариант
local M = {}

local saved_bg = nil -- просто храним цвет

function M.toggle()
  local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })

  if normal_hl.bg == nil then
    -- Восстанавливаем: если нет фона, значит он прозрачный
    if saved_bg then
      vim.cmd("hi! Normal guibg=" .. saved_bg)
      vim.opt.winblend = 0
      print("🎨 Фон восстановлен")
    end
  else
    -- Сохраняем текущий и делаем прозрачным
    saved_bg = string.format("#%06x", normal_hl.bg)
    vim.cmd("hi! Normal guibg=NONE ctermbg=NONE")
    vim.opt.winblend = 20
    print("🔮 Фон прозрачный")
  end
end

-- Хоткей
vim.keymap.set("n", "<leader>ut", M.toggle, { desc = "Toggle transparency" })

return M
