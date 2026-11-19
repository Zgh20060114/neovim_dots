-- wallpaper 配色方案:颜色由 matugen 从壁纸动态生成
-- 数据流:换壁纸 -> matugen 取主色 -> generate.py 推导完整调色板
--        -> ~/.config/nvim/palette.json -> SIGUSR1 -> 本文件重新加载
-- palette.json 不存在时,使用下方内置的兜底调色板,保证任何情况下都能正常启动

-- 透明背景:默认开启(配合 kitty 半透明);想关闭时在任意位置
-- 执行 vim.g.wallpaper_transparent = false 即可
local transparent = vim.g.wallpaper_transparent ~= false

local M = {}

-- 内置兜底调色板(深蓝基调,palette.json 缺失或损坏时使用)
local fallback = {
  primary = "#78a9ff",
  primary_dim = "#436fcd",
  primary_bright = "#a1c2ff",
  bg = "#1b1d2b",
  bg_dim = "#141622",
  bg_deep = "#10121a",
  bg_highlight = "#282c44",
  bg_search = "#3d4470",
  fg = "#c8d3f5",
  fg_muted = "#828bb8",
  fg_gutter = "#444a73",
  fg_dark = "#636da6",
  border = "#3b4261",
  border_highlight = "#78a9ff",
  selection = "#363c66",
  cursor_line = "#222538",
  float = { bg = "#141622", fg = "#c8d3f5", border = "#3b4261" },
  blue = "#82aaff",
  blue_dim = "#3e68d7",
  blue_bright = "#65bcff",
  cyan = "#86e1fc",
  green = "#c3e88d",
  green_bright = "#4fd6be",
  yellow = "#ffc777",
  orange = "#ff966c",
  red = "#ff757f",
  red_dim = "#c53b53",
  purple = "#c099ff",
  pink = "#fca7ea",
  comment = "#636da6",
  terminal_black = "#444a73",
  rosewater = "#f2d5cf",
  flamingo = "#eebebe",
  mauve = "#ca9ee6",
  maroon = "#ea999c",
  peach = "#ef9f76",
  teal = "#4fd6be",
  sky = "#99d1db",
  sapphire = "#85c1dc",
  lavender = "#babbf1",
  pink = "#9cb9e2", -- 兜底色板中 pink 同样是主色的同族亮色(非粉红)
  git = { add = "#b8db87", change = "#78a9ff", delete = "#e26a75" },
  diag = {
    error = "#ff757f",
    warn = "#ffc777",
    info = "#78a9ff",
    hint = "#4fd6be",
    bg_error = "#322739",
    bg_warn = "#3b3431",
    bg_info = "#273349",
    bg_hint = "#253741",
  },
  diff = {
    add = "#2c3247",
    change = "#2c3247",
    delete = "#3a2a35",
    text = "#3b4470",
  },
}

local function read_palette()
  local path = vim.fn.stdpath("config") .. "/palette.json"
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local content = file:read("a")
  file:close()
  local ok, data = pcall(vim.json.decode, content)
  if ok and type(data) == "table" then
    return data
  end
  return nil
end

M.palette = vim.tbl_deep_extend("force", fallback, read_palette() or {})
local p = M.palette

local bg = transparent and "none" or p.bg
local fbg = transparent and "none" or p.bg_dim -- 次级实底背景(侧栏/折叠等)

local hi = function(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end
local link = function(name, target)
  vim.api.nvim_set_hl(0, name, { link = target })
end

-- ============ 编辑器基础 ============
hi("Normal", { fg = p.fg, bg = bg })
hi("NormalNC", { fg = p.fg, bg = bg })
-- 浮窗边框用主色,醒目(高亮边框是整套配色的视觉锚点)
hi("NormalFloat", { fg = p.fg, bg = "none" })
hi("FloatBorder", { fg = p.primary, bg = "none" })
hi("FloatTitle", { fg = p.primary, bg = "none", bold = true })
hi("FloatFooter", { fg = p.fg_muted, bg = "none" })

hi("ColorColumn", { bg = p.bg_highlight })
hi("Cursor", { fg = p.bg, bg = p.primary }) -- 光标用主色,经 OSC12 与终端光标同色
hi("TermCursor", { fg = p.bg, bg = p.primary })
hi("TermCursorNC", { fg = p.bg, bg = p.fg_gutter })
hi("lCursor", { link = "Cursor" })
hi("CursorIM", { link = "Cursor" })
hi("CursorLine", { bg = p.cursor_line })
hi("CursorColumn", { bg = p.cursor_line })
hi("LineNr", { fg = p.fg_gutter })
hi("CursorLineNr", { fg = p.fg, bold = true })
hi("CursorLineFold", { fg = p.fg_dark, bg = p.cursor_line })
hi("VertSplit", { fg = p.border, bg = "none" })
hi("WinSeparator", { fg = p.border, bg = "none" })

hi("Visual", { bg = p.selection })
hi("VisualNOS", { bg = p.selection })
hi("Search", { bg = p.bg_search, fg = p.fg, bold = true })
hi("IncSearch", { bg = p.primary, fg = p.bg, bold = true })
hi("Substitute", { bg = p.red_dim, fg = p.fg })
hi("CurSearch", { link = "IncSearch" })

hi("StatusLine", { fg = p.fg, bg = p.bg_dim }) -- 实底,不再透出黑乎乎的壁纸暗部
hi("StatusLineNC", { fg = p.fg_muted, bg = p.bg_deep })
hi("TabLine", { fg = p.fg_muted, bg = p.bg_dim })
hi("TabLineFill", { bg = p.bg_deep })
hi("TabLineSel", { fg = p.fg, bg = p.bg_highlight, bold = true })
hi("WinBar", { fg = p.fg_muted, bg = "none" })
hi("WinBarNC", { fg = p.fg_gutter, bg = "none" })
hi("WildMenu", { fg = p.bg, bg = p.primary, bold = true })

hi("Folded", { fg = p.fg_muted, bg = fbg })
hi("FoldColumn", { fg = p.fg_gutter, bg = "none" })
hi("SignColumn", { fg = p.fg_gutter, bg = "none" })
hi("EndOfBuffer", { fg = p.bg_highlight })
hi("NonText", { fg = p.fg_gutter })
hi("Whitespace", { fg = p.bg_highlight })
hi("SpecialKey", { fg = p.fg_gutter })
hi("Conceal", { fg = p.fg_muted })
hi("MatchParen", { fg = p.primary_bright, bg = p.bg_highlight, bold = true })
hi("Pmenu", { fg = p.fg, bg = "none" })
hi("PmenuSel", { fg = p.fg, bg = p.bg_highlight, bold = true })
hi("PmenuKind", { fg = p.fg_muted, bg = "none" })
hi("PmenuKindSel", { fg = p.fg_muted, bg = p.bg_highlight })
hi("PmenuExtra", { fg = p.fg_dark, bg = "none" })
hi("PmenuExtraSel", { fg = p.fg_dark, bg = p.bg_highlight })
hi("PmenuSbar", { bg = p.bg_highlight })
hi("PmenuThumb", { bg = p.fg_gutter })
hi("Directory", { fg = p.primary })
hi("Title", { fg = p.primary, bold = true })
hi("MoreMsg", { fg = p.green, bold = true })
hi("ModeMsg", { fg = p.fg_muted, bold = true })
hi("Question", { fg = p.yellow })
hi("ErrorMsg", { fg = p.red, bold = true })
hi("WarningMsg", { fg = p.yellow, bold = true })
hi("NvimInternalError", { fg = p.red })
hi("QuickFixLine", { bg = p.bg_highlight })

-- ============ 基础语法 ============
hi("Comment", { fg = p.comment, italic = true })
hi("Constant", { fg = p.orange })
hi("String", { fg = p.green })
hi("Character", { fg = p.green })
hi("Number", { fg = p.orange })
hi("Boolean", { fg = p.orange, italic = true })
hi("Float", { fg = p.orange })
hi("Identifier", { fg = p.fg })
hi("Function", { fg = p.blue })
hi("Statement", { fg = p.purple })
hi("Conditional", { fg = p.purple, italic = true })
hi("Repeat", { fg = p.purple })
hi("Label", { fg = p.pink })
hi("Operator", { fg = p.sky })
hi("Keyword", { fg = p.purple, italic = true })
hi("Exception", { fg = p.purple })
hi("PreProc", { fg = p.yellow })
hi("Include", { fg = p.purple, italic = true })
hi("Define", { fg = p.purple })
hi("Macro", { fg = p.yellow })
hi("PreCondit", { fg = p.yellow })
hi("Type", { fg = p.yellow })
hi("StorageClass", { fg = p.yellow, italic = true })
hi("Structure", { fg = p.yellow })
hi("Typedef", { fg = p.yellow, italic = true })
hi("Special", { fg = p.pink })
hi("SpecialChar", { fg = p.teal })
hi("Tag", { fg = p.blue })
hi("Delimiter", { fg = p.fg_muted })
hi("SpecialComment", { fg = p.comment, italic = true })
hi("Debug", { fg = p.orange })
hi("Underlined", { fg = p.blue, underline = true })
hi("Ignore", { fg = p.fg_gutter })
hi("Error", { fg = p.red })
hi("Todo", { fg = p.yellow, bg = p.bg_highlight, bold = true })

-- ============ Treesitter 捕获组 ============
link("@comment", "Comment")
link("@comment.documentation", "Comment")
link("@punctuation", "Delimiter")
link("@punctuation.bracket", "Delimiter")
link("@punctuation.delimiter", "Delimiter")
link("@punctuation.special", "Special")
link("@string", "String")
link("@string.escape", "SpecialChar")
link("@character", "Character")
link("@character.special", "SpecialChar")
link("@number", "Number")
link("@boolean", "Boolean")
link("@float", "Float")
link("@constant", "Constant")
link("@constant.builtin", "Special")
link("@constant.macro", "Constant")
link("@constructor", "Type")
link("@function", "Function")
link("@function.builtin", "Special")
link("@function.macro", "Function")
link("@method", "Function")
link("@variable", "Identifier")
link("@variable.builtin", "Special")
link("@property", "Identifier")
link("@field", "Identifier")
link("@parameter", "Identifier")
link("@parameter.reference", "Identifier")
link("@label", "Label")
link("@keyword", "Keyword")
link("@keyword.function", "Keyword")
link("@keyword.operator", "Operator")
link("@keyword.return", "Keyword")
link("@keyword.import", "Keyword")
link("@keyword.conditional", "Conditional")
link("@keyword.repeat", "Repeat")
link("@keyword.exception", "Exception")
link("@operator", "Operator")
link("@type", "Type")
link("@type.builtin", "Type")
link("@type.qualifier", "StorageClass")
link("@module", "Structure")
link("@namespace", "Structure")
link("@annotation", "PreProc")
link("@attribute", "PreProc")
link("@definition", "Identifier")
link("@scope", "Identifier")
-- 代码注释里的拼写检查区维持注释样式(灰斜体)
link("@spell", "Comment")
-- markdown 正文也是 @spell,用语言限定符覆盖,保证正文是正常前景色
hi("@spell.markdown", { fg = p.fg })
link("@markup.heading", "Title")
link("@markup.heading.1.markdown", "Title")
link("@markup.heading.2.markdown", "Title")
link("@markup.raw", "String")
link("@markup.raw.block", "String")
link("@markup.link", "Underlined")
link("@markup.link.url", "Underlined")
link("@markup.list", "Special")
hi("@markup.italic", { italic = true })
hi("@markup.bold", { bold = true })
link("@markup.strong", "@markup.bold")
hi("@markup.strikethrough", { strikethrough = true })
link("@markup.quote", "Comment")
link("@markup.math", "Special")
link("@diff.plus", "DiffAdd")
link("@diff.minus", "DiffDelete")
link("@diff.delta", "DiffChange")
link("@tag", "Tag")
link("@tag.attribute", "Identifier")
link("@tag.delimiter", "Delimiter")
hi("@none", { fg = p.fg })

-- LSP 语义 token
link("@lsp.type.namespace", "@module")
link("@lsp.type.type", "@type")
link("@lsp.type.class", "@type")
link("@lsp.type.enum", "@type")
link("@lsp.type.interface", "@type")
link("@lsp.type.struct", "@type")
link("@lsp.type.parameter", "@parameter")
link("@lsp.type.variable", "@variable")
link("@lsp.type.property", "@property")
link("@lsp.type.enumMember", "Constant")
link("@lsp.type.event", "Special")
link("@lsp.type.function", "@function")
link("@lsp.type.method", "@method")
link("@lsp.type.macro", "Macro")
link("@lsp.type.decorator", "PreProc")
link("@lsp.type.regexp", "SpecialChar")
link("@lsp.type.formatSpecifier", "SpecialChar")
hi("@lsp.mod.deprecated", { fg = p.fg_gutter, strikethrough = true })
link("@lsp.mod.readonly", "Constant")
link("@lsp.mod.static", "Italic")
link("@lsp.typemod.variable.defaultLibrary", "Special")
link("@lsp.typemod.function.defaultLibrary", "Special")

-- ============ 诊断 ============
hi("DiagnosticError", { fg = p.diag.error })
hi("DiagnosticWarn", { fg = p.diag.warn })
hi("DiagnosticInfo", { fg = p.diag.info })
hi("DiagnosticHint", { fg = p.diag.hint })
hi("DiagnosticOk", { fg = p.diag.hint })
hi("DiagnosticVirtualTextError", { fg = p.diag.error, bg = p.diag.bg_error })
hi("DiagnosticVirtualTextWarn", { fg = p.diag.warn, bg = p.diag.bg_warn })
hi("DiagnosticVirtualTextInfo", { fg = p.diag.info, bg = p.diag.bg_info })
hi("DiagnosticVirtualTextHint", { fg = p.diag.hint, bg = p.diag.bg_hint })
hi("DiagnosticVirtualTextOk", { fg = p.diag.hint, bg = p.diag.bg_hint })
hi("DiagnosticUnderlineError", { sp = p.diag.error, underline = true })
hi("DiagnosticUnderlineWarn", { sp = p.diag.warn, underline = true })
hi("DiagnosticUnderlineInfo", { sp = p.diag.info, underline = true })
hi("DiagnosticUnderlineHint", { sp = p.diag.hint, underline = true })
hi("DiagnosticFloatingError", { fg = p.diag.error })
hi("DiagnosticFloatingWarn", { fg = p.diag.warn })
hi("DiagnosticFloatingInfo", { fg = p.diag.info })
hi("DiagnosticFloatingHint", { fg = p.diag.hint })
hi("DiagnosticSignError", { fg = p.diag.error })
hi("DiagnosticSignWarn", { fg = p.diag.warn })
hi("DiagnosticSignInfo", { fg = p.diag.info })
hi("DiagnosticSignHint", { fg = p.diag.hint })
hi("DiagnosticUnnecessary", { fg = p.fg_gutter })

-- ============ Diff / Git ============
hi("DiffAdd", { bg = p.diff.add, fg = p.git.add })
hi("DiffChange", { bg = p.diff.change, fg = p.fg })
hi("DiffDelete", { bg = p.diff.delete, fg = p.git.delete })
hi("DiffText", { bg = p.diff.text, fg = p.fg, bold = true })
hi("Added", { fg = p.git.add })
hi("Changed", { fg = p.git.change })
hi("Removed", { fg = p.git.delete })
hi("GitSignsAdd", { fg = p.git.add })
hi("GitSignsChange", { fg = p.git.change })
hi("GitSignsDelete", { fg = p.git.delete })
hi("GitSignsAddPreview", { bg = p.diff.add })
hi("GitSignsDeletePreview", { bg = p.diff.delete })
hi("GitSignsCurrentLineBlame", { fg = p.comment, italic = true })
link("MiniDiffSignAdd", "GitSignsAdd")
link("MiniDiffSignChange", "GitSignsChange")
link("MiniDiffSignDelete", "GitSignsDelete")

-- ============ 拼写 ============
hi("SpellBad", { sp = p.red, undercurl = true })
hi("SpellCap", { sp = p.blue, undercurl = true })
hi("SpellRare", { sp = p.purple, undercurl = true })
hi("SpellLocal", { sp = p.teal, undercurl = true })

-- ============ blink.cmp 补全 ============
hi("BlinkCmpMenu", { fg = p.fg, bg = "none" })
hi("BlinkCmpMenuBorder", { fg = p.primary, bg = "none" })
hi("BlinkCmpMenuSelection", { bg = p.bg_highlight, bold = true })
hi("BlinkCmpDocWindow", { fg = p.fg, bg = "none" })
hi("BlinkCmpDocBorder", { fg = p.primary, bg = "none" })
hi("BlinkCmpSignatureHelp", { fg = p.fg, bg = "none" })
hi("BlinkCmpSignatureHelpBorder", { fg = p.primary, bg = "none" })
hi("BlinkCmpLabel", { fg = p.fg })
hi("BlinkCmpLabelDescription", { fg = p.fg_dark })
hi("BlinkCmpLabelMatch", { fg = p.primary, bold = true })
hi("BlinkCmpLabelDetail", { fg = p.fg_dark })
hi("BlinkCmpKind", { fg = p.sky })
hi("BlinkCmpKindText", { fg = p.fg_muted })
hi("BlinkCmpKindMethod", { fg = p.blue })
hi("BlinkCmpKindFunction", { fg = p.blue })
hi("BlinkCmpKindConstructor", { fg = p.yellow })
hi("BlinkCmpKindField", { fg = p.green })
hi("BlinkCmpKindVariable", { fg = p.cyan })
hi("BlinkCmpKindClass", { fg = p.yellow })
hi("BlinkCmpKindInterface", { fg = p.yellow })
hi("BlinkCmpKindModule", { fg = p.orange })
hi("BlinkCmpKindProperty", { fg = p.green })
hi("BlinkCmpKindUnit", { fg = p.orange })
hi("BlinkCmpKindValue", { fg = p.peach })
hi("BlinkCmpKindEnum", { fg = p.yellow })
hi("BlinkCmpKindKeyword", { fg = p.purple })
hi("BlinkCmpKindSnippet", { fg = p.teal })
hi("BlinkCmpKindColor", { fg = p.pink })
hi("BlinkCmpKindFile", { fg = p.blue })
hi("BlinkCmpKindReference", { fg = p.cyan })
hi("BlinkCmpKindFolder", { fg = p.blue })
hi("BlinkCmpKindEnumMember", { fg = p.orange })
hi("BlinkCmpKindConstant", { fg = p.orange })
hi("BlinkCmpKindStruct", { fg = p.yellow })
hi("BlinkCmpKindEvent", { fg = p.pink })
hi("BlinkCmpKindOperator", { fg = p.sky })
hi("BlinkCmpKindTypeParameter", { fg = p.green })
hi("BlinkCmpGhostText", { fg = p.fg_gutter })

-- ============ nvim-cmp 补全 ============
-- cmp 用 CmpItem*/Pmenu 系列高亮组(与上面的 BlinkCmp* 组互不冲突,
-- 保留 blink 段以便日后回退)
hi("CmpItemAbbr", { fg = p.fg })
hi("CmpItemAbbrMatch", { fg = p.primary, bold = true }) -- 匹配到的字符用主色加粗
hi("CmpItemAbbrMatchFuzzy", { fg = p.primary_bright })
hi("CmpItemAbbrDeprecated", { fg = p.fg_gutter, strikethrough = true })
hi("CmpItemKind", { fg = p.sky })
hi("CmpItemMenu", { fg = p.fg_dark, italic = true })
hi("CmpItemKindText", { fg = p.fg_muted })
hi("CmpItemKindMethod", { fg = p.blue })
hi("CmpItemKindFunction", { fg = p.blue })
hi("CmpItemKindConstructor", { fg = p.yellow })
hi("CmpItemKindField", { fg = p.green })
hi("CmpItemKindVariable", { fg = p.cyan })
hi("CmpItemKindClass", { fg = p.yellow })
hi("CmpItemKindInterface", { fg = p.yellow })
hi("CmpItemKindModule", { fg = p.orange })
hi("CmpItemKindProperty", { fg = p.green })
hi("CmpItemKindUnit", { fg = p.orange })
hi("CmpItemKindValue", { fg = p.peach })
hi("CmpItemKindEnum", { fg = p.yellow })
hi("CmpItemKindKeyword", { fg = p.purple })
hi("CmpItemKindSnippet", { fg = p.teal })
hi("CmpItemKindColor", { fg = p.pink })
hi("CmpItemKindFile", { fg = p.blue })
hi("CmpItemKindReference", { fg = p.cyan })
hi("CmpItemKindFolder", { fg = p.blue })
hi("CmpItemKindEnumMember", { fg = p.orange })
hi("CmpItemKindConstant", { fg = p.orange })
hi("CmpItemKindStruct", { fg = p.yellow })
hi("CmpItemKindEvent", { fg = p.pink })
hi("CmpItemKindOperator", { fg = p.sky })
hi("CmpItemKindTypeParameter", { fg = p.green })

-- ============ which-key / noice / 通知 ============
hi("WhichKey", { fg = p.primary, bold = true })
hi("WhichKeyGroup", { fg = p.peach })
hi("WhichKeyDesc", { fg = p.fg })
hi("WhichKeySeparator", { fg = p.fg_gutter })
hi("WhichKeyBorder", { link = "FloatBorder" })
hi("NoiceCmdline", { fg = p.primary })
hi("NoiceCmdlineIcon", { fg = p.primary })
hi("NoiceCmdlinePopupBorder", { link = "FloatBorder" })
hi("NoiceConfirmBorder", { link = "FloatBorder" })
hi("NoiceFormatProgressDone", { bg = p.primary })
hi("NoiceFormatProgressTodo", { bg = p.bg_highlight })

hi("SnacksNotifierTrace", { fg = p.fg_muted })
hi("SnacksNotifierTraceBorder", { fg = p.fg_gutter })
hi("SnacksNotifierTraceIcon", { fg = p.fg_muted })
hi("SnacksNotifierTraceTitle", { fg = p.fg_muted })
hi("SnacksNotifierDebug", { fg = p.fg_muted })
hi("SnacksNotifierDebugBorder", { fg = p.fg_gutter })
hi("SnacksNotifierDebugIcon", { fg = p.fg_muted })
hi("SnacksNotifierDebugTitle", { fg = p.fg_muted })
hi("SnacksNotifierInfo", { fg = p.diag.info })
hi("SnacksNotifierInfoBorder", { fg = p.diag.info })
hi("SnacksNotifierInfoIcon", { fg = p.diag.info })
hi("SnacksNotifierInfoTitle", { fg = p.diag.info })
hi("SnacksNotifierWarn", { fg = p.diag.warn })
hi("SnacksNotifierWarnBorder", { fg = p.diag.warn })
hi("SnacksNotifierWarnIcon", { fg = p.diag.warn })
hi("SnacksNotifierWarnTitle", { fg = p.diag.warn })
hi("SnacksNotifierError", { fg = p.diag.error })
hi("SnacksNotifierErrorBorder", { fg = p.diag.error })
hi("SnacksNotifierErrorIcon", { fg = p.diag.error })
hi("SnacksNotifierErrorTitle", { fg = p.diag.error })

-- ============ snacks(仪表盘/选择器/缩进/滚动) ============
hi("SnacksDashboardHeader", { fg = p.primary, bold = true })
hi("SnacksDashboardDesc", { fg = p.fg })
hi("SnacksDashboardKey", { fg = p.peach, bold = true })
hi("SnacksDashboardIcon", { fg = p.primary })
hi("SnacksDashboardDir", { fg = p.fg_muted })
hi("SnacksDashboardFooter", { fg = p.mauve, italic = true })
hi("SnacksDashboardSpecial", { fg = p.pink })
hi("SnacksPicker", { link = "NormalFloat" })
hi("SnacksPickerBorder", { link = "FloatBorder" })
hi("SnacksPickerTitle", { link = "FloatTitle" })
hi("SnacksPickerPreviewTitle", { link = "FloatTitle" })
hi("SnacksPickerInput", { fg = p.fg, bg = p.float.bg })
hi("SnacksPickerSelected", { fg = p.primary, bold = true })
hi("SnacksPickerRow", { fg = p.fg_muted })
hi("SnacksPickerMatch", { fg = p.primary_bright, bold = true })
hi("SnacksIndent", { fg = p.bg_highlight })
hi("SnacksIndentScope", { fg = p.fg_dark })
hi("SnacksZenBorder", { link = "FloatBorder" })

-- ============ 其他插件 ============
hi("FlashMatch", { bg = p.bg_search, fg = p.fg })
hi("FlashCurrent", { bg = p.primary, fg = p.bg, bold = true })
hi("FlashLabel", { bg = p.red, fg = p.bg, bold = true })
hi("FlashBackdrop", { fg = p.fg_gutter })
hi("FlashPromptIcon", { fg = p.peach })

hi("TreesitterContext", { fg = p.fg_muted, bg = p.bg_dim })
hi("TreesitterContextLineNumber", { fg = p.fg_gutter, bg = p.bg_dim })
hi("TreesitterContextBottom", { sp = p.border, underline = true })

hi("IblIndent", { fg = p.bg_highlight, nocombine = true })
hi("IblScope", { fg = p.fg_dark, nocombine = true })
link("MiniIndentscopeSymbol", "IblScope")

hi("RainbowDelimiterRed", { fg = p.red })
hi("RainbowDelimiterYellow", { fg = p.yellow })
hi("RainbowDelimiterBlue", { fg = p.blue })
hi("RainbowDelimiterOrange", { fg = p.orange })
hi("RainbowDelimiterGreen", { fg = p.green })
hi("RainbowDelimiterViolet", { fg = p.purple })
hi("RainbowDelimiterCyan", { fg = p.cyan })
hi("RainbowDelimiterPink", { fg = p.pink })

hi("LazyButton", { fg = p.fg, bg = p.bg_highlight })
hi("LazyButtonActive", { fg = p.bg, bg = p.primary, bold = true })
hi("LazyH1", { fg = p.bg, bg = p.primary, bold = true })
hi("LazyH2", { fg = p.primary, bold = true })
hi("LazyNormal", { link = "NormalFloat" })
hi("LazySpecial", { fg = p.primary })
hi("LazyProgressDone", { fg = p.primary })
hi("LazyProgressTodo", { fg = p.fg_gutter })
hi("LazyCommit", { fg = p.green })
hi("LazyReasonPlugin", { fg = p.mauve })
hi("LazyReasonKeys", { fg = p.teal })
hi("LazyReasonEvent", { fg = p.yellow })
hi("LazyReasonCmd", { fg = p.peach })

hi("MiniFilesBorder", { link = "FloatBorder" })
hi("MiniFilesBorderModified", { fg = p.orange })
hi("MiniFilesDirectory", { link = "Directory" })
hi("MiniFilesFile", { fg = p.fg })
hi("MiniFilesTitle", { fg = p.primary, bg = "none", bold = true })
hi("MiniFilesTitleFocused", { fg = p.primary_bright, bg = "none", bold = true })
hi("MiniFilesCursorLine", { bg = p.cursor_line })

-- snacks 浮窗(文件树/浮动终端/选择器都走这套 winhighlight)
hi("SnacksNormal", { fg = p.fg, bg = "none" })
hi("SnacksNormalNC", { fg = p.fg, bg = "none" })
hi("SnacksWinBar", { fg = p.fg_muted, bg = "none" })
hi("SnacksWinBarNC", { fg = p.fg_gutter, bg = "none" })
hi("SnacksTitle", { fg = p.primary, bg = "none", bold = true })
hi("SnacksFooter", { fg = p.fg_muted, bg = "none" })
hi("SnacksWinSeparator", { fg = p.border, bg = "none" })

hi("MiniHipatternsFixme", { fg = p.bg, bg = p.red, bold = true })
hi("MiniHipatternsHack", { fg = p.bg, bg = p.yellow, bold = true })
hi("MiniHipatternsNote", { fg = p.bg, bg = p.blue, bold = true })
hi("MiniHipatternsTodo", { fg = p.bg, bg = p.peach, bold = true })

hi("MiniJump", { bg = p.primary, fg = p.bg, bold = true })
hi("MiniSurround", { bg = p.peach, fg = p.bg, bold = true })
hi("MiniJump2dSpot", { fg = p.primary_bright, bold = true, nocombine = true })

hi("MiniStatuslineModeNormal", { fg = p.bg, bg = p.primary, bold = true })
hi("MiniStatuslineModeInsert", { fg = p.bg, bg = p.green, bold = true })
hi("MiniStatuslineModeVisual", { fg = p.bg, bg = p.pink, bold = true })
hi("MiniStatuslineModeReplace", { fg = p.bg, bg = p.purple, bold = true })
hi("MiniStatuslineModeCommand", { fg = p.bg, bg = p.yellow, bold = true })
hi("MiniStatuslineModeOther", { fg = p.bg, bg = p.teal, bold = true })
hi("MiniStatuslineFilename", { fg = p.fg_muted, bg = fbg })
hi("MiniStatuslineDevinfo", { fg = p.fg, bg = p.bg_highlight })
hi("MiniStatuslineInactive", { fg = p.fg_gutter, bg = fbg })

hi("UfoFoldedBg", { bg = p.bg_highlight })
hi("UfoFoldedEllipsis", { fg = p.fg_gutter })
hi("UfoPreviewSalt", { fg = p.primary })

hi("TroubleText", { fg = p.fg })
hi("TroubleCount", { fg = p.pink, bold = true })
hi("TroubleNormal", { link = "NormalFloat" })
hi("TroubleBorder", { link = "FloatBorder" })

-- ============ 终端 16 色(:terminal / low-level ANSI) ============
local term = {
  [0] = p.terminal_black,
  [1] = p.red,
  [2] = p.green,
  [3] = p.yellow,
  [4] = p.blue,
  [5] = p.purple,
  [6] = p.cyan,
  [7] = p.fg,
  [8] = p.fg_dark,
  [9] = p.red,
  [10] = p.green_bright,
  [11] = p.yellow,
  [12] = p.blue_bright,
  [13] = p.pink,
  [14] = p.teal,
  [15] = p.fg,
}
for i, color in pairs(term) do
  vim.g["terminal_color_" .. i] = color
end

-- ============ 光标颜色同步(终端 OSC 12) ============
-- kitty 的块光标由终端自己绘制,nvim 的 Cursor 高亮不会自动生效;
-- 通过 OSC 12 直写终端序列,把光标染成主色,与主题保持一致
local function sync_cursor_color()
  pcall(vim.api.nvim_chan_send, 2, "\x1b]12;" .. p.primary .. "\x1b\\")
end
sync_cursor_color()

-- 退出 nvim 时把光标颜色还给终端默认值
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    pcall(vim.api.nvim_chan_send, 2, "\x1b]12;\x1b\\")
  end,
})

-- ============ SIGUSR1 热重载 ============
-- matugen 换壁纸后会 pkill -USR1 nvim,这里收到信号即重新加载配色
if not _G.__wallpaper_signal then
  _G.__wallpaper_signal = true
  local sig = vim.uv.new_signal()
  if sig then
    sig:start("sigusr1", vim.schedule_wrap(function()
      vim.cmd.colorscheme("wallpaper")
    end))
  end
end

vim.g.colors_name = "wallpaper"
return M
