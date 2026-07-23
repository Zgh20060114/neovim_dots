-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.cursorcolumn = true

-- vim.opt_local.wrap = true
-- vim.opt_local.linebreak = true -- 避免单词被拆开折叠
-- vim.opt_local.breakindent = true -- 为折叠行添加缩进
--
-- vim.g.encoding = "UTF-8"

-- -- 缩进4个空格等于一个Tab
-- vim.opt.tabstop = 2
-- vim.opt.softtabstop = 2
--
-- -- >> << 时移动长度
-- vim.opt.shiftwidth = 2
--
-- -- 空格替代tab
-- vim.opt.expandtab = true
--
-- -- 不可见字符的显示，这里只把空格显示为一个点
-- vim.opt.listchars = "space:·"

-- vim.g.mason_url = "https://github.moeyy.xyz/"
--
-- require("catppuccin").load("mocha")
vim.env.HTTP_PROXY = "http://127.0.0.1:7897"
vim.env.HTTPS_PROXY = "http://127.0.0.1:7897"

vim.api.nvim_set_keymap("i", "<C-S-v>", '<Esc>"+p', { noremap = true })
vim.keymap.set("v", "<leader>{", "c{}<Esc>P", { desc = "Wrap selection with {}" })
vim.keymap.set("v", "<leader><", "c<><Esc>P", { desc = "Wrap selection with <>" })
vim.keymap.set("v", "<leader>(", "c()<Esc>P", { desc = "Wrap selection with ()" })
vim.keymap.set("v", '<leader>"', 'c""<Esc>P', { desc = 'Wrap selection with "' })
vim.keymap.set("v", "<leader>'", "c''<Esc>P", { desc = "Wrap selection with '" })
-- vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = "*",
  command = "silent! write",
})

-- function Transparent(color)
--   color = zephyr
--   vim.cmd.colorscheme(color)
--   vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--   vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- end
-- Transparent()
