-- 配置 VimTeX 使用 Zathura 打开 PDF
return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_view_forward_search_on_start = 1
    vim.g.vimtex_compiler_method = "latexmk"
    -- 编译产物输出到 build 目录，保持源目录整洁
    vim.g.vimtex_compiler_latexmk = {
      build_dir = "build",
    }
    -- 关键：告诉 VimTeX PDF 在 build/ 里
    vim.g.vimtex_view_general_viewer = "zathura"
    vim.g.vimtex_view_general_options = "-l @line @pdf"
  end,
  keys = {
    { "<leader>lc", "<cmd>VimtexCompile<cr>", desc = "LaTeX: 编译当前文件" },
    { "<leader>lv", "<cmd>VimtexView<cr>", desc = "LaTeX: 查看 PDF" },
    { "<leader>ll", "<cmd>VimtexCompileToggle<cr>", desc = "LaTeX: 开启/关闭自动编译" },
  },
}
