-- 诊断浮动窗口(aevre 式):光标可进入浮窗复制报错文本
-- 键位挂在 LazyVim 规格的 keys 上:lazy.nvim 在插件加载后应用,
-- 必然覆盖 LazyVim 核心自带的 <leader>cd(普通 open_float,光标不进入)
-- 连按两次进入浮窗(nvim 原生 toggle),V 选中 y 复制,Esc 退出
return {
  "LazyVim/LazyVim",
  keys = {
    -- {
    --   "<leader>cd",
    --   function()
    --     vim.diagnostic.open_float({ scope = "cursor", focus = true })
    --   end,
    --   desc = "Line Diagnostics (focused)",
    -- },
    {
      "<leader>cd",
      function()
        -- open_float 返回 (消息, 窗口ID)
        local _, winId = vim.diagnostic.open_float({ scope = "cursor", focus = true })
        -- 如果成功获取到浮窗ID，则直接切换焦点
        if winId and vim.api.nvim_win_is_valid(winId) then
          vim.api.nvim_set_current_win(winId)
        end
      end,
      desc = "Line Diagnostics (focused, one-press)",
    },
    -- {
    --   "<leader>cD",
    --   function()
    --     vim.diagnostic.open_float({ scope = "buffer", focus = true })
    --   end,
    --   desc = "Buffer Diagnostics (focused)",
    -- },
    {
      "<leader>cD",
      function()
        -- open_float 返回 (消息, 窗口ID)
        local _, winId = vim.diagnostic.open_float({ scope = "buffer", focus = true })
        -- 如果成功获取到浮窗ID，则直接切换焦点
        if winId and vim.api.nvim_win_is_valid(winId) then
          vim.api.nvim_set_current_win(winId)
        end
      end,
      desc = "Buffer Diagnostics (focused, one-press)",
    },
  },
}
