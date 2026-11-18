-- 补全菜单外观:对齐 aevre 的 blink.cmp 样式
-- 四列布局(图标 | 名称+来源描述 | 类型 | 补全源)+ 圆角边框
-- + LSP 语义着色 + 自动文档浮窗 + 签名浮窗
-- 只改 blink.cmp 的展示参数,不增删任何补全来源
return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      menu = {
        border = "rounded",
        scrollbar = false,
        draw = {
          padding = 0,
          treesitter = { "lsp" }, -- 补全项按 LSP 语义高亮,像正常代码一样上色
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "kind" },
            { "source_name" },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = { border = "rounded" },
      },
      -- 注意:不要设置 list.selection.preselect = false,
      -- 否则菜单弹出时没有预选项,Enter 无法直接补全(blink 默认预选第一项)
      -- list = { selection = { preselect = false, auto_insert = true } },
    },
    signature = {
      enabled = true,
      window = {
        border = "rounded",
        treesitter_highlighting = true, -- 签名参数也用语法高亮
        show_documentation = true,
      },
    },
    -- 命令行补全:配合 cmdline.nvim,输 : 命令时直接弹补全菜单
    cmdline = {
      enabled = true,
      completion = { menu = { auto_show = true } },
    },
  },
}
