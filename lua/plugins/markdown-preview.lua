return {
  -- install without yarn or npm
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      -- ===================== 基础行为配置 =====================
      vim.g.mkdp_auto_start = 0 -- 不自动启动预览
      vim.g.mkdp_auto_close = 1 -- 离开md文件自动关闭预览
      vim.g.mkdp_refresh_slow = 0 -- 实时刷新预览（编辑公式时超实用）
      vim.g.mkdp_echo_preview_url = 1 -- 启动预览时输出URL（关键！）
      vim.g.mkdp_theme = "dark" -- 预览页暗色主题（可改为light）

      -- ===================== 浏览器/网络配置 =====================
      -- 根据你的系统指定浏览器（解决不自动打开问题）
      -- macOS: "Google Chrome" / "Safari" / "Firefox"
      -- Linux: "google-chrome" / "firefox"
      -- Windows: "chrome.exe" / "msedge.exe"
      vim.g.mkdp_browser = "firefox"
      vim.g.mkdp_port = 8888 -- 自定义端口，避免占用

      -- ===================== LaTeX 公式渲染配置 =====================
      vim.g.mkdp_use_katex = 1 -- 强制用KaTeX渲染公式（核心！）
      vim.g.mkdp_preview_options = {
        katex = {
          throwOnError = false, -- 忽略公式小错误（比如少个括号）
          errorColor = "#ff0000", -- 公式错误时显示红色
        },
        disable_sync_scroll = 0, -- 开启同步滚动
        disable_filename = 1, -- 隐藏预览页文件名（更简洁）
      }
    end,
  },
}
