-- clangd 22 参数兼容修复:
-- LazyVim clangd extra 默认传 `--function-arg-placeholders`(无值形式),
-- clangd 22.x 视为无效参数并每次启动报错(见 lsp.log,已出现 81 次),
-- 需要显式给布尔值;同时 clangd 默认 info 级日志会全量灌进 lsp.log
-- (已涨到 176MB),加 --log=error 控制日志量
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      clangd = {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders=true", -- clangd 22 要求显式布尔值
          "--fallback-style=llvm",
          "--log=error", -- 只记 error,避免 lsp.log 失控膨胀
        },
      },
    },
  },
}
