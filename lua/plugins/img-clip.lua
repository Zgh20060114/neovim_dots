return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    -- add options here
    -- or leave it empty to use the default settings
    default = {
      dir_path = function()
        local current_file = vim.api.nvim_buf_get_name(0)
        -- if current_file == "" then
        --   local fallback_dir = "assets_unnamed"
        --   if not vim.fn.isdirectory(fallback_dir) then
        --     vim.fn.mkdir(fallback_dir, "p")
        --   end
        --   return fallback_dir
        -- end

        local file_name = vim.fn.fnamemodify(current_file, ":t:r")
        local target_dir = "assets_" .. file_name

        if not vim.fn.isdirectory(target_dir) then
          vim.fn.mkdir(target_dir, "p")
        end

        return target_dir
      end,
      use_absolute_path = false,
      relative_to_current_file = true,
      verbose = true,
    },
  },
  keys = {
    -- suggested keymap
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
  },
}
