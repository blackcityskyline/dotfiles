return {
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      require("colorizer").setup({
        "*", -- Включить для всех файлов
        css = { rgb_fn = true, hsl_fn = true }, -- Поддержка rgb() и hsl()
        html = { names = false }, -- Не показывать имена цветов (red, blue)
        javascript = { rgb_fn = true },
        typescript = { rgb_fn = true },
        javascriptreact = { rgb_fn = true },
        typescriptreact = { rgb_fn = true },
        scss = { rgb_fn = true },
        sass = { rgb_fn = true },
        tailwindcss = { mode = "foreground" },
        markdown = { names = true }, -- Только имена цветов
      })
    end,
  },
}
