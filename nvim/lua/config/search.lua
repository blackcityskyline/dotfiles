-- ПОИСК С LAZY-LOADING TELESCOPE
local function search_path()
  vim.ui.input({
    prompt = "📁 Путь для поиска: ",
    default = vim.fn.getcwd(),
  }, function(input_path)
    if not input_path or input_path == "" then
      return
    end

    local path = vim.fn.expand(input_path)
    if vim.fn.isdirectory(path) == 0 then
      vim.notify("❌ Нет такой папки: " .. path, vim.log.levels.ERROR)
      return
    end

    -- ГРУЗИМ TELESCOPE ПЕРЕД ИСПОЛЬЗОВАНИЕМ
    require("lazy").load({ plugins = { "telescope.nvim" } })

    -- ЖДЁМ ЗАГРУЗКИ
    vim.defer_fn(function()
      require("telescope.builtin").find_files({
        cwd = path,
        hidden = true,
        prompt_title = "🔍 " .. path,
      })
    end, 100)
  end)
end

vim.keymap.set("n", "<leader>fs", search_path, { desc = "Search in PATH" })
