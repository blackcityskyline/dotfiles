-- Универсальный вариант

-- Функция получения цвета фона текущей темы
local function get_theme_background()
  local themes = {
    ["tokyonight-moon"] = "#1a1b26",
    ["tokyonight-night"] = "#1a1b26",
    ["tokyonight-storm"] = "#24283b",
    ["catppuccin-mocha"] = "#1e1e2e",
    ["gruvbox"] = "#282828",
    ["onedark"] = "#282c34",
  }

  local current = vim.g.colors_name or "tokyonight-moon"
  return themes[current] or "#000000" -- чёрный по умолчанию
end

-- Устанавливаем нормальный фон при старте
vim.defer_fn(function()
  vim.cmd("hi! Normal guibg=" .. get_theme_background())
  vim.opt.winblend = 0
end, 100)

-- Переключатель
vim.keymap.set("n", "<leader>ut", function()
  local hl = vim.api.nvim_get_hl(0, { name = "Normal" })

  if hl.bg == nil then
    -- Восстанавливаем фон темы
    vim.cmd("hi! Normal guibg=" .. get_theme_background())
    vim.opt.winblend = 0
    print("🎨 Фон восстановлен")
  else
    -- Делаем прозрачным
    vim.cmd("hi! Normal guibg=NONE")
    vim.opt.winblend = 20
    print("🔮 Фон прозрачный")
  end
end, { desc = "Toggle background" })
