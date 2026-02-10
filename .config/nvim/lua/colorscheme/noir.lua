-- Noir: Pure Black & White colorscheme
-- #000000 background, #FFFFFF text, off-white accents, gray comments.

local M = {}

-- Define all highlight groups for the noir colorscheme
function M.setup()
    -- Reset everything
    vim.cmd("highlight clear")
    if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
    end
    vim.g.colors_name = "noir"

    local hl          = function(group, opts)
        vim.api.nvim_set_hl(0, group, opts)
    end

    -- ─── Palette ────────────────────────────────────────────────
    local bg          = "#000000"
    local fg          = "#FFFFFF"
    local offwhite    = "#D4D4D4" -- keywords, types, builtins
    local dim         = "#B0B0B0" -- strings, constants
    local comment     = "#666666"
    local linenum     = "#555555"
    local cursorln    = "#111111"
    local visual      = "#333333"
    local search_bg   = "#444444"
    local statusbg    = "#1A1A1A"
    local statusfg    = "#CCCCCC"
    local pmenu_bg    = "#141414"
    local pmenu_fg    = "#DDDDDD"
    local border      = "#333333"
    local folded      = "#222222"
    local nontext     = "#444444"

    -- Diagnostics (keep a splash of color for visibility)
    local err         = "#FF5555"
    local warn        = "#FFAA00"
    local info        = "#888888"
    local hint        = "#777777"

    -- ─── Editor UI ──────────────────────────────────────────────
    hl("Normal", { fg = fg, bg = bg })
    hl("NormalFloat", { fg = fg, bg = "#0A0A0A" })
    hl("FloatBorder", { fg = border, bg = "#0A0A0A" })
    hl("FloatTitle", { fg = offwhite, bg = "#0A0A0A", bold = true })
    hl("CursorLine", { bg = cursorln })
    hl("CursorLineNr", { fg = fg, bold = true })
    hl("LineNr", { fg = linenum })
    hl("SignColumn", { bg = bg })
    hl("ColorColumn", { bg = "#0D0D0D" })
    hl("Visual", { bg = visual })
    hl("VisualNOS", { bg = visual })
    hl("Search", { fg = fg, bg = search_bg })
    hl("IncSearch", { fg = bg, bg = fg })
    hl("CurSearch", { fg = bg, bg = offwhite })
    hl("Substitute", { fg = bg, bg = dim })
    hl("MatchParen", { fg = fg, bg = "#444444", bold = true })
    hl("Pmenu", { fg = pmenu_fg, bg = pmenu_bg })
    hl("PmenuSel", { fg = fg, bg = "#2A2A2A" })
    hl("PmenuSbar", { bg = "#1A1A1A" })
    hl("PmenuThumb", { bg = "#444444" })
    hl("StatusLine", { fg = statusfg, bg = statusbg })
    hl("StatusLineNC", { fg = comment, bg = "#0D0D0D" })
    hl("TabLine", { fg = comment, bg = statusbg })
    hl("TabLineFill", { bg = bg })
    hl("TabLineSel", { fg = fg, bg = bg, bold = true })
    hl("WinSeparator", { fg = border })
    hl("VertSplit", { fg = border })
    hl("Folded", { fg = comment, bg = folded })
    hl("FoldColumn", { fg = comment, bg = bg })
    hl("NonText", { fg = nontext })
    hl("SpecialKey", { fg = nontext })
    hl("Whitespace", { fg = "#222222" })
    hl("EndOfBuffer", { fg = "#222222" })
    hl("Directory", { fg = offwhite })
    hl("Title", { fg = fg, bold = true })
    hl("Question", { fg = offwhite })
    hl("MoreMsg", { fg = offwhite })
    hl("ModeMsg", { fg = fg })
    hl("WarningMsg", { fg = warn })
    hl("ErrorMsg", { fg = err, bold = true })
    hl("WildMenu", { fg = bg, bg = offwhite })
    hl("Conceal", { fg = comment })
    hl("SpellBad", { undercurl = true, sp = err })
    hl("SpellCap", { undercurl = true, sp = warn })
    hl("SpellRare", { undercurl = true, sp = dim })
    hl("SpellLocal", { undercurl = true, sp = info })

    -- ─── Syntax (Vim legacy groups) ────────────────────────────
    hl("Comment", { fg = comment, italic = true })
    hl("Constant", { fg = dim })
    hl("String", { fg = dim })
    hl("Character", { fg = dim })
    hl("Number", { fg = offwhite })
    hl("Boolean", { fg = offwhite })
    hl("Float", { fg = offwhite })
    hl("Identifier", { fg = fg })
    hl("Function", { fg = offwhite })
    hl("Statement", { fg = offwhite })
    hl("Conditional", { fg = offwhite })
    hl("Repeat", { fg = offwhite })
    hl("Label", { fg = offwhite })
    hl("Operator", { fg = fg })
    hl("Keyword", { fg = offwhite })
    hl("Exception", { fg = offwhite })
    hl("PreProc", { fg = offwhite })
    hl("Include", { fg = offwhite })
    hl("Define", { fg = offwhite })
    hl("Macro", { fg = offwhite })
    hl("PreCondit", { fg = offwhite })
    hl("Type", { fg = offwhite })
    hl("StorageClass", { fg = offwhite })
    hl("Structure", { fg = offwhite })
    hl("Typedef", { fg = offwhite })
    hl("Special", { fg = offwhite })
    hl("SpecialChar", { fg = dim })
    hl("Tag", { fg = offwhite })
    hl("Delimiter", { fg = fg })
    hl("SpecialComment", { fg = comment, italic = true })
    hl("Debug", { fg = err })
    hl("Underlined", { fg = fg, underline = true })
    hl("Ignore", { fg = comment })
    hl("Error", { fg = err, bold = true })
    hl("Todo", { fg = bg, bg = offwhite, bold = true })

    -- ─── Treesitter ─────────────────────────────────────────────
    hl("@variable", { fg = fg })
    hl("@variable.builtin", { fg = offwhite })
    hl("@variable.parameter", { fg = fg, italic = true })
    hl("@variable.member", { fg = fg })
    hl("@constant", { fg = dim })
    hl("@constant.builtin", { fg = offwhite })
    hl("@constant.macro", { fg = offwhite })
    hl("@module", { fg = offwhite })
    hl("@string", { fg = dim })
    hl("@string.escape", { fg = offwhite })
    hl("@string.special", { fg = offwhite })
    hl("@character", { fg = dim })
    hl("@number", { fg = offwhite })
    hl("@boolean", { fg = offwhite })
    hl("@float", { fg = offwhite })
    hl("@function", { fg = offwhite })
    hl("@function.call", { fg = offwhite })
    hl("@function.builtin", { fg = offwhite })
    hl("@function.macro", { fg = offwhite })
    hl("@method", { fg = offwhite })
    hl("@method.call", { fg = offwhite })
    hl("@constructor", { fg = offwhite })
    hl("@keyword", { fg = offwhite })
    hl("@keyword.function", { fg = offwhite })
    hl("@keyword.operator", { fg = offwhite })
    hl("@keyword.return", { fg = offwhite })
    hl("@keyword.import", { fg = offwhite })
    hl("@conditional", { fg = offwhite })
    hl("@repeat", { fg = offwhite })
    hl("@label", { fg = offwhite })
    hl("@operator", { fg = fg })
    hl("@exception", { fg = offwhite })
    hl("@type", { fg = offwhite })
    hl("@type.builtin", { fg = offwhite })
    hl("@type.definition", { fg = offwhite })
    hl("@type.qualifier", { fg = offwhite })
    hl("@attribute", { fg = offwhite })
    hl("@property", { fg = fg })
    hl("@field", { fg = fg })
    hl("@parameter", { fg = fg, italic = true })
    hl("@punctuation.delimiter", { fg = fg })
    hl("@punctuation.bracket", { fg = fg })
    hl("@punctuation.special", { fg = offwhite })
    hl("@comment", { fg = comment, italic = true })
    hl("@comment.documentation", { fg = "#777777", italic = true })
    hl("@tag", { fg = offwhite })
    hl("@tag.attribute", { fg = fg })
    hl("@tag.delimiter", { fg = fg })
    hl("@text", { fg = fg })
    hl("@text.strong", { fg = fg, bold = true })
    hl("@text.emphasis", { fg = fg, italic = true })
    hl("@text.underline", { fg = fg, underline = true })
    hl("@text.strike", { fg = comment, strikethrough = true })
    hl("@text.title", { fg = fg, bold = true })
    hl("@text.uri", { fg = dim, underline = true })
    hl("@text.todo", { fg = bg, bg = offwhite, bold = true })
    hl("@text.note", { fg = info })
    hl("@text.warning", { fg = warn })
    hl("@text.danger", { fg = err })

    -- ─── LSP Semantic Tokens ────────────────────────────────────
    hl("@lsp.type.class", { fg = offwhite })
    hl("@lsp.type.decorator", { fg = offwhite })
    hl("@lsp.type.enum", { fg = offwhite })
    hl("@lsp.type.enumMember", { fg = dim })
    hl("@lsp.type.function", { fg = offwhite })
    hl("@lsp.type.interface", { fg = offwhite })
    hl("@lsp.type.keyword", { fg = offwhite })
    hl("@lsp.type.macro", { fg = offwhite })
    hl("@lsp.type.method", { fg = offwhite })
    hl("@lsp.type.namespace", { fg = offwhite })
    hl("@lsp.type.parameter", { fg = fg, italic = true })
    hl("@lsp.type.property", { fg = fg })
    hl("@lsp.type.struct", { fg = offwhite })
    hl("@lsp.type.type", { fg = offwhite })
    hl("@lsp.type.typeParameter", { fg = offwhite })
    hl("@lsp.type.variable", { fg = fg })

    -- ─── Diagnostics ────────────────────────────────────────────
    hl("DiagnosticError", { fg = err })
    hl("DiagnosticWarn", { fg = warn })
    hl("DiagnosticInfo", { fg = info })
    hl("DiagnosticHint", { fg = hint })
    hl("DiagnosticUnderlineError", { undercurl = true, sp = err })
    hl("DiagnosticUnderlineWarn", { undercurl = true, sp = warn })
    hl("DiagnosticUnderlineInfo", { undercurl = true, sp = info })
    hl("DiagnosticUnderlineHint", { undercurl = true, sp = hint })
    hl("DiagnosticVirtualTextError", { fg = err, bg = "#1A0000" })
    hl("DiagnosticVirtualTextWarn", { fg = warn, bg = "#1A1400" })
    hl("DiagnosticVirtualTextInfo", { fg = info, bg = "#0D0D0D" })
    hl("DiagnosticVirtualTextHint", { fg = hint, bg = "#0D0D0D" })
    hl("DiagnosticSignError", { fg = err })
    hl("DiagnosticSignWarn", { fg = warn })
    hl("DiagnosticSignInfo", { fg = info })
    hl("DiagnosticSignHint", { fg = hint })

    -- ─── Git / Diff ─────────────────────────────────────────────
    hl("DiffAdd", { bg = "#0D1A0D" })
    hl("DiffChange", { bg = "#1A1A0D" })
    hl("DiffDelete", { fg = "#555555", bg = "#1A0D0D" })
    hl("DiffText", { bg = "#2A2A0D" })
    hl("Added", { fg = "#AAAAAA" })
    hl("Changed", { fg = "#999999" })
    hl("Removed", { fg = "#777777" })

    -- GitSigns (grayscale)
    hl("GitSignsAdd", { fg = "#AAAAAA" })
    hl("GitSignsChange", { fg = "#888888" })
    hl("GitSignsDelete", { fg = "#666666" })
    hl("GitSignsAddNr", { fg = "#AAAAAA" })
    hl("GitSignsChangeNr", { fg = "#888888" })
    hl("GitSignsDeleteNr", { fg = "#666666" })
    hl("GitSignsAddLn", { bg = "#0D1A0D" })
    hl("GitSignsChangeLn", { bg = "#1A1A0D" })
    hl("GitSignsDeleteLn", { bg = "#1A0D0D" })

    -- ─── Telescope ──────────────────────────────────────────────
    hl("TelescopeNormal", { fg = fg, bg = bg })
    hl("TelescopeBorder", { fg = border, bg = bg })
    hl("TelescopeTitle", { fg = offwhite, bold = true })
    hl("TelescopePromptNormal", { fg = fg, bg = "#0A0A0A" })
    hl("TelescopePromptBorder", { fg = border, bg = "#0A0A0A" })
    hl("TelescopePromptTitle", { fg = fg, bg = "#0A0A0A", bold = true })
    hl("TelescopeResultsNormal", { fg = fg, bg = bg })
    hl("TelescopeResultsBorder", { fg = border, bg = bg })
    hl("TelescopePreviewNormal", { fg = fg, bg = bg })
    hl("TelescopePreviewBorder", { fg = border, bg = bg })
    hl("TelescopeSelection", { bg = "#1A1A1A" })
    hl("TelescopeMatching", { fg = fg, bold = true })

    -- ─── Trouble ────────────────────────────────────────────────
    hl("TroubleNormal", { fg = fg, bg = bg })
    hl("TroubleText", { fg = fg })
    hl("TroubleCount", { fg = offwhite, bold = true })

    -- ─── Noice / Notify ─────────────────────────────────────────
    hl("NoiceCmdlinePopup", { fg = fg, bg = "#0A0A0A" })
    hl("NoiceCmdlinePopupBorder", { fg = border })
    hl("NotifyERRORBorder", { fg = err })
    hl("NotifyWARNBorder", { fg = warn })
    hl("NotifyINFOBorder", { fg = info })
    hl("NotifyDEBUGBorder", { fg = comment })
    hl("NotifyTRACEBorder", { fg = comment })
    hl("NotifyERRORTitle", { fg = err })
    hl("NotifyWARNTitle", { fg = warn })
    hl("NotifyINFOTitle", { fg = info })
    hl("NotifyDEBUGTitle", { fg = comment })
    hl("NotifyTRACETitle", { fg = comment })

    -- ─── Which-Key ──────────────────────────────────────────────
    hl("WhichKey", { fg = offwhite })
    hl("WhichKeyGroup", { fg = dim })
    hl("WhichKeySeparator", { fg = comment })
    hl("WhichKeyDesc", { fg = fg })
    hl("WhichKeyFloat", { bg = "#0A0A0A" })

    -- ─── nvim-cmp ───────────────────────────────────────────────
    hl("CmpItemAbbr", { fg = pmenu_fg })
    hl("CmpItemAbbrDeprecated", { fg = comment, strikethrough = true })
    hl("CmpItemAbbrMatch", { fg = fg, bold = true })
    hl("CmpItemAbbrMatchFuzzy", { fg = fg, bold = true })
    hl("CmpItemKind", { fg = offwhite })
    hl("CmpItemMenu", { fg = comment })

    -- ─── Indent / Rainbow Delimiters (grayscale) ────────────────
    hl("RainbowDelimiterWhite", { fg = "#FFFFFF" })
    hl("RainbowDelimiterGray1", { fg = "#CCCCCC" })
    hl("RainbowDelimiterGray2", { fg = "#AAAAAA" })
    hl("RainbowDelimiterGray3", { fg = "#888888" })
    hl("RainbowDelimiterGray4", { fg = "#666666" })

    -- ─── Leap / Flash ───────────────────────────────────────────
    hl("LeapMatch", { fg = bg, bg = fg, bold = true })
    hl("LeapLabelPrimary", { fg = bg, bg = offwhite, bold = true })
    hl("FlashLabel", { fg = bg, bg = fg, bold = true })
    hl("FlashMatch", { fg = offwhite })
    hl("FlashCurrent", { fg = fg, bold = true })

    -- ─── NeoTree ────────────────────────────────────────────────
    hl("NeoTreeNormal", { fg = fg, bg = bg })
    hl("NeoTreeNormalNC", { fg = fg, bg = bg })
    hl("NeoTreeDirectoryName", { fg = offwhite })
    hl("NeoTreeDirectoryIcon", { fg = offwhite })
    hl("NeoTreeFileName", { fg = fg })
    hl("NeoTreeGitAdded", { fg = "#AAAAAA" })
    hl("NeoTreeGitModified", { fg = "#888888" })
    hl("NeoTreeGitDeleted", { fg = "#666666" })
    hl("NeoTreeGitUntracked", { fg = "#999999" })
    hl("NeoTreeIndentMarker", { fg = border })
    hl("NeoTreeRootName", { fg = fg, bold = true })
    hl("NeoTreeCursorLine", { bg = cursorln })

    -- ─── Snacks ─────────────────────────────────────────────────
    hl("SnacksNormal", { fg = fg, bg = bg })
    hl("SnacksBorder", { fg = border })
    hl("SnacksTitle", { fg = offwhite, bold = true })
end

return M
