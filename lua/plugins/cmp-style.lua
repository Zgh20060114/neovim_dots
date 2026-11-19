-- nvim-cmp 窗口样式:边框改用主题主色
-- cmp 默认把浮窗边框高亮映射到 Pmenu(灰白前景色),
-- 这里改回 FloatBorder(wallpaper 配色里的主色),对齐之前 blink 的观感
return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    -- 关键词模式修正:cmp 默认把 `foo-bar` 视为一个整体搜索词
    -- (为 --flag 类 shell 选项设计),导致 `height-BO` 整串去匹配,
    -- 永远匹配不到 BODY_HEIGHT。改为 \k\+ 后,- 是词边界,
    -- `height-BO` 的搜索词只取 `BO`,可以正常补全
    opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
      keyword_pattern = [[\k\+]],
    })
    opts.window = vim.tbl_deep_extend("force", opts.window or {}, {
      completion = {
        border = "rounded",
        winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:PmenuSel",
      },
      documentation = {
        border = "rounded",
        winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:PmenuSel",
      },
    })
  end,
}
