-- 壁纸联动动态配色:colors/wallpaper.lua 由 matugen 生成的 palette.json 驱动
-- 换壁纸时整套配色自动跟随(matugen -> palette.json -> SIGUSR1 热重载)
-- 原 gruvbox 配色方案已完整备份到 theme.lua.zgh,想回退直接覆盖回来即可
-- 回退命令: cp ~/.config/nvim/lua/plugins/theme.lua.zgh ~/.config/nvim/lua/plugins/theme.lua

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "wallpaper", -- 对应 colors/wallpaper.lua
    },
  },
}

-- return {
--   {
--     "ellisonleao/gruvbox.nvim",
--     priority = 1000,
--     config = function()
--       require("gruvbox").setup({
--         contrast = "hard",
--         transparent_mode = true, -- 开启透明模式
--       })
--       vim.cmd.colorscheme("gruvbox")
--     end,
--   },
-- }
