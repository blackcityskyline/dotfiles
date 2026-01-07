return {
  -- УДАЛИТЕ эту строку - такого модуля нет в LazyVim!
  -- { import = "lazyvim.plugins.extras.ui.telescope" },

  -- ОСТАВЬТЕ эту часть - это нормальная настройка Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- Можно добавить настройки если нужно:
    config = function()
      require("telescope").setup({
        -- ваши настройки
      })
    end,
  },
}
