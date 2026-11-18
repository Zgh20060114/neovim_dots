return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    picker = {
      sources = {
        explorer = {
          -- 文件树默认就显示 dotfiles 与 gitignored 文件
          -- (纯显示层开关, 底层给 fd 加 --hidden/--no-ignore, 不影响 git 行为)
          -- 切换键用 snacks 默认的 <a-i> (ignored) / <a-h> (dotfiles)
          -- hidden = true,
          -- ignored = true,
        },
      },
    },
  },
}
