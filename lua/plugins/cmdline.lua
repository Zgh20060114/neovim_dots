-- 命令行浮动窗口:aevre/cmdline.nvim(noice 配置兼容格式)
-- 基于 nvim 0.12 的 UI2 / vim.ui_attach,把 : / ? input() 等渲染成浮动窗口
-- 注意:与 noice.nvim 互斥(两者都接管命令行),noice 已在下方禁用
---@type LazyPluginSpec
return {
  {
    "aevre/cmdline.nvim",
    name = "cmdline.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" }, -- popupmenu 后端
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
        opts = {
          presets = {
            cmdline_popup = { position = "top", title = "Command", icon = "󰘳" },
            lua = { position = "top", title = "Lua", icon = "" },
            filter = { position = "top", title = "Filter", icon = "󰈲" },
            input = { position = "top", title = "Input", icon = "󰌌" },
            rename = { position = "top", title = "Rename", icon = "󰏫" },
            mini = { position = "mini", border = "none" },
          },
          width = { value = "60%", min = 40, max = 100 },
          border = "rounded",
        },
        format = {
          cmdline = { pattern = "^:", view = "cmdline_popup", icon = "󰘳" },
          -- 默认把 / ? 映射到 mini 小条,这里改成和 : 一样的顶部浮窗
          search_down = { kind = "search", pattern = "^/", view = "cmdline_popup", icon = "", title = "Search" },
          search_up = { kind = "search", pattern = "^%?", view = "cmdline_popup", icon = "", title = "Search" },
          filter = { pattern = "^:%s*!", view = "filter", icon = "󰈲" },
          help = { pattern = "^:%s*he?l?p?%s+", view = "help", icon = "󰋖" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, view = "lua", icon = "" },
          expression = { pattern = "^=", view = "cmdline_popup", icon = "", title = "Expression" },
          input = { view = "input", icon = "󰌌" },
          rename = { view = "rename", icon = "󰏫" },
        },
      },
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "notify",
      },
      popupmenu = {
        enabled = true,
        backend = "nui",
        kind_icons = {},
      },
    },
  },
  -- noice 与 cmdline.nvim 都接管命令行,二选一;不适应时删掉本行即可还原
  { "folke/noice.nvim", enabled = false },
}
