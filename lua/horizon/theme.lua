local M = {}

---@param color string A hex color
---@param percent float a negative number darkens and a positive one brightens
---@return string
local function tint(color, percent)
  assert(color and percent, 'cannot alter a color without specifying a color and percentage')
  local r = tonumber(color:sub(2, 3), 16)
  local g = tonumber(color:sub(4, 5), 16)
  local b = tonumber(color:sub(6), 16)
  if not r or not g or not b then return 'NONE' end
  local blend = function(component)
    component = math.floor(component * (1 + percent))
    return math.min(math.max(component, 0), 255)
  end
  return string.format('#%02x%02x%02x', blend(r), blend(g), blend(b))
end

-- These colours represent values not directly taken from the
-- original theme, but are similar to/inspired by the original.
-- they are largely used to plug in the gaps where there is no
-- color specified for something that needs to be highlighted
-- in the neovim context
---@param data CustomPalette
---@return CustomPalette
local function get_custom_highlights(data)
  local d = data ---@module 'horizon.palette-dark'
  local t, p = d.theme, d.palette
  return {
    hint = p.syntax.lavender,
    info = p.syntax.turquoise,
    warn = p.syntax.apricot,
    error = t.error,
    error_bg = tint(t.error, -0.8), -- #33222c,
    warn_bg = tint(p.syntax.apricot, -0.8), -- #332e31,
    info_bg = tint(p.syntax.turquoise, -0.7), -- #1e3132,
    hint_bg = tint(p.syntax.lavender, -0.7), -- #252732,
    purple1 = tint(p.syntax.lavender, -0.2), -- #B180D7,
    gray = '#4B4C53',
    gold = '#C09553',
    blue = '#042E48',
    diff_change = '#273842',
    diff_text = '#314753',
    ok = t.positive,
  }
end

---@param theme horizon.HighlightDef
---@param palette {[string]: {[string]: string}}
local function get_lsp_kind_highlights(theme, palette)
  return {
    -- LSP Kind Items
    ['module'] = { fg = palette.syntax.rosebud },
    ['snippet'] = { fg = palette.syntax.lavender },
    ['folder'] = { fg = theme.fg },
    ['color'] = { fg = theme.fg },
    ['file'] = { link = 'Directory' },
    ['text'] = { link = '@string' },
    ['method'] = { link = '@method' },
    ['function'] = { link = '@function' },
    ['constructor'] = { link = '@constructor' },
    ['field'] = { link = '@field' },
    ['variable'] = { link = '@variable' },
    ['property'] = { link = '@property' },
    ['unit'] = { link = '@constant' },
    ['value'] = { link = '@variable' },
    ['enum'] = { link = '@type' },
    ['keyword'] = { link = '@keyword' },
    ['reference'] = { link = '@parameter.reference' },
    ['constant'] = { link = '@constant' },
    ['struct'] = { link = '@structure' },
    ['event'] = { link = '@variable' },
    ['operator'] = { link = '@operator' },
    ['namespace'] = { link = '@namespace' },
    ['package'] = { link = '@include' },
    ['string'] = { link = '@string' },
    ['number'] = { link = '@number' },
    ['boolean'] = { link = '@boolean' },
    ['array'] = { link = '@repeat' },
    ['object'] = { link = '@type' },
    ['key'] = { link = '@field' },
    ['null'] = { link = '@symbol' },
    ['enumMember'] = { link = '@field' },
    ['class'] = { link = '@lsp.type.class' },
    ['interface'] = { link = '@lsp.type.interface' },
    ['typeParameter'] = { link = '@lsp.type.parameter' },
  }
end

---@param data ThemeData
---@param custom CustomPalette
---@return horizon.HighlightDef
local function get_highlights(data, custom)
  local d = data ---@module 'horizon.palette-dark'
  local t, p = d.theme, d.palette
  return {
    -- Editor
    ['Normal'] = { fg = t.fg, bg = t.bg },
    ['NormalNC'] = { fg = t.fg, bg = t.bg },
    ['SignColumn'] = {},
    ['MsgArea'] = { fg = t.fg, bg = t.bg },
    ['ModeMsg'] = { fg = t.fg, bg = p.ui.background },
    ['MsgSeparator'] = { fg = t.winseparator_fg, bg = t.bg },
    ['SpellBad'] = { sp = p.syntax.cranberry, undercurl = true },
    ['SpellCap'] = { sp = p.syntax.tacao, undercurl = true },
    ['SpellLocal'] = { sp = p.syntax.rosebud, underline = true },
    ['SpellRare'] = { sp = p.syntax.lavender, underline = true },
    ['Pmenu'] = { fg = t.float_border, bg = 'NONE' },
    ['PmenuSel'] = { fg = p.syntax.fg, bg = 'NONE', bold = true },
    ['PmenuSbar'] = { bg = 'NONE' },
    ['PmenuThumb'] = { bg = 'NONE' },
    ['WildMenu'] = { fg = t.fg, bg = custom.blue },
    ['Folded'] = { fg = custom.gray, bg = p.ui.background },
    ['FoldColumn'] = { fg = custom.gray, bg = p.ui.background },
    ['LineNr'] = { fg = t.inactive_line_number_fg },
    ['NormalFloat'] = { fg = t.float_fg, bg = 'NONE' },
    ['FloatBorder'] = { fg = t.float_border, bg = 'NONE' },
    ['Whitespace'] = { fg = p.ui.backgroundAlt, bg = 'NONE' },
    ['VertSplit'] = { fg = t.winseparator_fg, bg = t.bg },
    ['CursorLine'] = { bg = t.cursorline_bg },
    ['CursorColumn'] = { bg = p.ui.background },
    ['CursorLineNr'] = { fg = t.active_line_number_fg, bg = t.cursorline_bg, bold = true },
    ['CursorLineSign'] = { link = 'CursorLine' },
    ['CursorLineFold'] = { link = 'CursorLine' },
    ['CurSearch'] = { bg = t.string.fg, fg = 'white', bold = true, underline = true },
    ['ColorColumn'] = { fg = t.color_column_fg },
    ['Visual'] = { fg = t.visual_fg, bg = t.visual_bg },
    ['VisualNOS'] = { bg = p.ui.background },
    ['WarningMsg'] = { fg = custom.warn, bg = t.bg },
    ['DiffAdd'] = { bg = t.diff_added_bg },
    ['DiffDelete'] = { bg = t.diff_deleted_bg },
    ['DiffChange'] = { bg = custom.diff_change },
    ['DiffText'] = { bg = custom.diff_text },
    ['QuickFixLine'] = { bg = custom.blue },
    ['MatchParen'] = { fg = t.match_paren_fg, bg = t.match_paren_bg, underline = true, bold = true },
    ['Cursor'] = { fg = t.cursor_fg, bg = t.cursor_bg },
    ['lCursor'] = { fg = t.cursor_fg, bg = t.cursor_bg },
    ['CursorIM'] = { fg = t.cursor_fg, bg = t.cursor_bg },
    ['TermCursor'] = { fg = t.term_cursor_fg, bg = t.term_cursor_bg },
    ['TermCursorNC'] = { fg = t.term_cursor_fg, bg = t.term_cursor_bg },
    ['Conceal'] = { fg = custom.gray },
    ['Directory'] = { fg = t.keyword.fg, bold = true },
    ['SpecialKey'] = { fg = p.syntax.cranberry, bold = true },
    ['ErrorMsg'] = { fg = p.ui.negative, bold = true },
    ['Search'] = { fg = p.ui.darkText, bg = p.syntax.apricot, bold = true, underline = true },
    ['IncSearch'] = { bg = custom.blue, underline = true },
    ['Substitute'] = { bg = custom.blue },
    ['MoreMsg'] = { fg = p.syntax.apricot },
    ['Question'] = { fg = p.syntax.apricot },
    ['EndOfBuffer'] = { fg = t.bg },
    ['NonText'] = { fg = p.ui.backgroundAlt, bg = 'NONE' },
    ['TabLine'] = { fg = p.ui.lightText, bg = p.ui.background },
    ['TabLineSel'] = { fg = t.fg, bg = p.ui.background },
    ['TabLineFill'] = { fg = p.ui.background, bg = p.ui.background },
    ['IlluminatedWord'] = { fg = p.syntax.fg, bg = 'NONE', bold = true },

    -- Code
    ['Comment'] = t.comment,
    ['Variable'] = { fg = p.syntax.purple },
    ['String'] = t.string,
    ['Character'] = { fg = p.syntax.rosebud },
    ['Number'] = { fg = p.syntax.apricot },
    ['Float'] = { fg = p.syntax.apricot },
    ['Boolean'] = { fg = p.syntax.apricot },
    ['Constant'] = t.constant,
    ['Type'] = { fg = p.syntax.tacao },
    ['Function'] = { fg = t.func.fg, bg = t.func.bg, bold = true },
    ['Keyword'] = { fg = p.syntax.yellow, bg = p.syntax.yellow_bg, bold = true },
    ['Conditional'] = { fg = p.syntax.yellow },
    ['Repeat'] = { fg = p.syntax.yellow },
    ['Operator'] = { fg = p.syntax.strong_yellow, bg = 'NONE' },
    ['PreProc'] = { fg = p.syntax.lavender },
    ['Include'] = { fg = p.syntax.lavender },
    ['Exception'] = { fg = p.syntax.lavender },
    ['StorageClass'] = { fg = p.syntax.tacao },
    ['Structure'] = { fg = p.syntax.tacao },
    ['Typedef'] = { link = 'Type' },
    ['Define'] = { fg = p.syntax.lavender },
    ['Macro'] = { fg = p.syntax.lavender },
    ['Debug'] = { fg = p.syntax.cranberry },
    ['Title'] = { fg = p.syntax.tacao, bold = true },
    ['Label'] = { fg = p.syntax.cranberry },
    ['SpecialChar'] = { fg = p.syntax.rosebud },
    ['Delimiter'] = { fg = t.delimiter.fg },
    ['SpecialComment'] = { fg = t.fg },
    ['Tag'] = { fg = p.syntax.cranberry },
    ['Bold'] = { bold = true },
    ['Italic'] = { italic = true },
    ['Underlined'] = { underline = true },
    ['Ignore'] = { fg = p.ui.accentAlt, bold = true },
    ['Todo'] = { fg = p.ui.warning, bold = true },
    ['Error'] = { fg = p.ui.negative, bold = true },
    ['Statement'] = { fg = p.syntax.lavender },
    ['Identifier'] = t.variable,
    ['PreCondit'] = { fg = p.syntax.lavender },
    ['Special'] = { fg = p.syntax.apricot },

    -- Treesitter
    ['@comment'] = { link = 'Comment' },
    ['@variable'] = { link = 'Variable' },
    ['@string'] = { link = 'String' },
    ['@string.regex'] = { link = 'String' },
    ['@string.escape'] = { link = 'String' },
    ['@character'] = { link = 'String' },
    ['@character.special'] = { link = 'SpecialChar' },
    ['@number'] = { link = 'Number' },
    ['@float'] = { link = 'Float' },
    ['@boolean'] = { link = 'Boolean' },
    ['@constant'] = { link = 'Constant' },
    ['@constant.builtin'] = { link = 'Constant' },
    ['@constructor'] = { fg = p.syntax.lavender, bold = true },
    ['@type'] = { link = 'Type' },
    ['@include'] = { link = 'Include' },
    ['@exception'] = { link = 'Exception' },
    ['@keyword'] = { link = 'Keyword' },
    ['@keyword.return'] = { link = 'Keyword' },
    ['@keyword.operator'] = { link = 'Keyword' },
    ['@keyword.function'] = { fg = p.syntax.green, bg = 'NONE' },
    ['@function'] = { link = 'Function' },
    ['@function.builtin'] = { link = 'Function' },
    ['@method'] = { link = 'Function' },
    ['@function.macro'] = { link = 'Function' },
    ['@conditional'] = { link = 'Conditional' },
    ['@repeat'] = { link = 'Repeat' },
    ['@operator'] = { fg = p.syntax.strong_yellow, bg = 'NONE' },
    ['@preproc'] = { link = 'PreProc' },
    ['@storageclass'] = { link = 'StorageClass' },
    ['@structure'] = { link = 'Structure' },
    ['@type.definition'] = { link = 'Typedef' },
    ['@define'] = { link = 'Define' },
    ['@note'] = { link = 'Comment' },
    ['@none'] = { fg = p.ui.lightText },
    ['@todo'] = { link = 'Todo' },
    ['@debug'] = { link = 'Debug' },
    ['@danger'] = { link = 'Error' },
    ['@title'] = { link = 'Title' },
    ['@label'] = { link = 'Label' },
    ['@tag.delimiter'] = { fg = p.syntax.cranberry },
    ['@punctuation.delimiter'] = { link = 'Delimiter' },
    ['@punctuation.bracket'] = { fg = p.ansi.bright.cyan, bg = 'NONE' },
    ['@punctuation.special'] = { link = 'Delimiter' },
    ['@tag'] = { link = 'Tag' },
    ['@strong'] = { link = 'Bold' },
    ['@emphasis'] = { link = 'Italic' },
    ['@underline'] = { link = 'Underline' },
    ['@strike'] = { strikethrough = true },
    ['@string.special'] = { fg = t.fg },
    ['@environment.name'] = { fg = p.syntax.turquoise },
    ['@variable.builtin'] = { fg = p.syntax.tacao },
    ['@const.macro'] = { fg = p.syntax.apricot },
    ['@type.builtin'] = { fg = p.syntax.apricot },
    ['@annotation'] = { fg = p.syntax.turquoise },
    ['@namespace'] = { fg = p.syntax.turquoise },
    ['@symbol'] = { fg = t.fg },
    ['@field'] = { fg = p.syntax.fg },
    ['@property'] = { fg = p.syntax.fg },
    ['@parameter'] = { fg = p.syntax.fg },
    ['@parameter.reference'] = t.parameter,
    ['@attribute'] = { fg = p.syntax.fg },
    ['@text'] = { fg = p.ui.lightText },
    ['@text.emphasis'] = { bold = true },
    ['@text.reference'] = { fg = t.link.fg, sp = p.ui.accent, underline = true, bold = true },
    ['@tag.attribute'] = { fg = p.syntax.apricot, italic = true },
    ['@error'] = { fg = custom.error },
    ['@warning'] = { fg = custom.warn },
    ['@query.linter.error'] = { fg = custom.error },
    ['@uri'] = { fg = p.syntax.turquoise, underline = true },
    ['@math'] = { fg = p.syntax.tacao },

    -- LspSemanticTokens
    ['@lsp.type.namespace'] = { link = '@namespace' },
    ['@lsp.type.type'] = { link = '@type' },
    ['@lsp.type.class'] = { link = '@type' },
    ['@lsp.type.enum'] = { link = '@type' },
    ['@lsp.type.interface'] = { link = '@type' },
    ['@lsp.type.struct'] = { link = '@structure' },
    ['@lsp.type.typeParameter'] = { link = 'TypeDef' },
    ['@lsp.type.variable'] = { link = '@variable' },
    ['@lsp.type.property'] = { link = '@property' },
    ['@lsp.type.enumMember'] = { link = '@constant' },
    ['@lsp.type.function'] = { link = '@function' },
    ['@lsp.type.method'] = { link = '@method' },
    ['@lsp.type.macro'] = { link = '@macro' },
    ['@lsp.type.decorator'] = { link = '@function' },
    ['@lsp.typemod.variable.readonly'] = { link = '@constant' },
    ['@lsp.typemod.method.defaultLibrary'] = { link = '@function.builtin' },
    ['@lsp.typemod.function.defaultLibrary'] = { link = '@function.builtin' },
    ['@lsp.typemod.variable.defaultLibrary'] = { link = '@variable.builtin' },
    ['@lsp.typemod.variable.global'] = { fg = t.constant.fg, bold = true },
    ['@lsp.mod.deprecated'] = { strikethrough = true },

    -- LSP
    ['DiagnosticOk'] = { fg = custom.ok },
    ['DiagnosticHint'] = { fg = custom.hint },
    ['DiagnosticInfo'] = { fg = custom.info },
    ['DiagnosticWarn'] = { fg = custom.warn },
    ['DiagnosticError'] = { fg = custom.error },
    ['DiagnosticOther'] = { fg = custom.purple1 },
    ['DiagnosticSignHint'] = { link = 'DiagnosticHint' },
    ['DiagnosticSignInfo'] = { link = 'DiagnosticInfo' },
    ['DiagnosticSignWarn'] = { link = 'DiagnosticWarn' },
    ['DiagnosticSignError'] = { link = 'DiagnosticError' },
    ['DiagnosticSignOther'] = { link = 'DiagnosticOther' },
    ['DiagnosticSignWarning'] = { link = 'DiagnosticWarn' },
    ['DiagnosticFloatingHint'] = { link = 'DiagnosticHint' },
    ['DiagnosticFloatingInfo'] = { link = 'DiagnosticInfo' },
    ['DiagnosticFloatingWarn'] = { link = 'DiagnosticWarn' },
    ['DiagnosticFloatingError'] = { link = 'DiagnosticError' },
    ['DiagnosticUnderlineHint'] = { sp = custom.hint, undercurl = true },
    ['DiagnosticUnderlineInfo'] = { sp = custom.info, undercurl = true },
    ['DiagnosticUnderlineWarn'] = { sp = custom.warn, undercurl = true },
    ['DiagnosticUnderlineError'] = { sp = custom.error, undercurl = true },
    ['DiagnosticSignInformation'] = { link = 'DiagnosticInfo' },
    ['DiagnosticVirtualTextHint'] = { fg = custom.hint, bg = custom.hint_bg },
    ['DiagnosticVirtualTextInfo'] = { fg = custom.info, bg = custom.info_bg },
    ['DiagnosticVirtualTextWarn'] = { fg = custom.warn, bg = custom.warn_bg },
    ['DiagnosticVirtualTextError'] = { fg = custom.error, bg = custom.error_bg },
    ['NvimTreeLspDiagnosticsError'] = { link = 'DiagnosticError' },
    ['NvimTreeLspDiagnosticsWarning'] = { link = 'DiagnosticWarn' },
    ['NvimTreeLspDiagnosticsInformation'] = { link = 'DiagnosticInfo' },
    ['NvimTreeLspDiagnosticsInfo'] = { link = 'DiagnosticInfo' },
    ['NvimTreeLspDiagnosticsHint'] = { link = 'DiagnosticHint' },
    ['LspDiagnosticsUnderlineError'] = { link = 'DiagnosticUnderlineError' },
    ['LspDiagnosticsUnderlineWarning'] = { link = 'DiagnosticUnderlineWarn' },
    ['LspDiagnosticsUnderlineInformation'] = { link = 'DiagnosticUnderlineInfo' },
    ['LspDiagnosticsUnderlineInfo'] = { link = 'DiagnosticUnderlineInfo' },
    ['LspDiagnosticsUnderlineHint'] = { link = 'DiagnosticUnderlineHint' },
    ['LspReferenceRead'] = { bg = p.ui.accent },
    ['LspReferenceText'] = { bg = p.ui.accent },
    ['LspReferenceWrite'] = { bg = p.ui.accent },
    ['LspCodeLens'] = { fg = t.codelens_fg, italic = true },
    ['LspCodeLensSeparator'] = { fg = t.codelens_fg, italic = false },
    ['LspInlayHint'] = { bg = t.cursorline_bg, fg = t.comment.fg },

    -- StatusLine
    ['StatusLine'] = { fg = t.statusline_fg, bg = t.statusline_bg },
    ['StatusLineNC'] = { fg = p.ui.background, bg = t.statusline_bg },
    ['StatusLineSeparator'] = { fg = t.statusline_bg },
    ['StatusLineTerm'] = { fg = t.statusline_bg },
    ['StatusLineTermNC'] = { fg = t.statusline_bg },
  }
end

---@param data ThemeData
---@param custom CustomPalette
---@return horizon.HighlightDef
local function get_plugin_highlights(data, custom)
  local d = data ---@module 'horizon.palette-dark'
  local t, p = d.theme, d.palette
  local lsp_kinds = get_lsp_kind_highlights(t, p)
  return {
    whichkey = {
      ['WhichKey'] = { fg = p.syntax.lavender },
      ['WhichKeySeperator'] = { fg = p.syntax.tacao },
      ['WhichKeyGroup'] = { fg = p.syntax.cranberry },
      ['WhichKeyDesc'] = { fg = t.fg },
      ['WhichKeyFloat'] = { bg = t.float_bg },
    },
    gitsigns = {
      ['SignAdd'] = { fg = t.git_added_fg },
      ['SignChange'] = { fg = t.git_modified_fg },
      ['SignDelete'] = { fg = t.git_deleted_fg },
      ['GitSignsAdd'] = { fg = t.git_added_fg },
      ['GitSignsChange'] = { fg = t.git_modified_fg },
      ['GitSignsDelete'] = { fg = t.git_deleted_fg },
      ['GitSignsUntracked'] = { fg = t.git_untracked_fg },
      ['GitSignsAddInline'] = { link = 'DiffText' },
      ['GitSignsChangeInline'] = { link = 'DiffChange' },
      ['GitSignsDeleteInline'] = { link = 'DiffDelete' },
    },
    quickscope = {
      ['QuickScopePrimary'] = { fg = '#ff007c', underline = true },
      ['QuickScopeSecondary'] = { fg = '#00dfff', underline = true },
    },
    telescope = {
      ['TelescopeSelection'] = { bg = custom.blue },
      ['TelescopeSelectionCaret'] = { fg = p.syntax.cranberry, bg = custom.blue },
      ['TelescopeMatching'] = { fg = p.syntax.tacao, bold = true, italic = true },
      ['TelescopeBorder'] = { fg = t.float_border, bg = 'NONE' },
      ['TelescopeNormal'] = { fg = p.ui.lightText, bg = p.ui.background },
      ['TelescopePromptTitle'] = { fg = p.syntax.apricot },
      ['TelescopePromptPrefix'] = { fg = p.syntax.turquoise },
      ['TelescopeResultsTitle'] = { fg = p.syntax.apricot },
      ['TelescopePreviewTitle'] = { fg = p.syntax.apricot },
      ['TelescopePromptCounter'] = { fg = p.syntax.cranberry },
      ['TelescopePreviewHyphen'] = { fg = p.syntax.cranberry },
    },
    nvim_tree = {
      ['NvimTreeFolderIcon'] = { fg = custom.gold },
      ['NvimTreeIndentMarker'] = { fg = custom.gray },
      ['NvimTreeNormal'] = { fg = t.sidebar_fg, bg = t.sidebar_bg },
      ['NvimTreeVertSplit'] = { fg = t.sidebar_bg, bg = t.sidebar_bg },
      ['NvimTreeFolderName'] = { fg = t.sidebar_fg },
      ['NvimTreeOpenedFolderName'] = { fg = t.sidebar_fg, bold = true, italic = true },
      ['NvimTreeEmptyFolderName'] = t.comment,
      ['NvimTreeGitIgnored'] = t.comment,
      ['NvimTreeImageFile'] = { fg = p.ui.lightText },
      ['NvimTreeSpecialFile'] = { fg = p.syntax.apricot },
      ['NvimTreeEndOfBuffer'] = { fg = t.comment.fg },
      ['NvimTreeCursorLine'] = { fg = t.cursorline_fg, bg = 'NONE', bold = true },
      ['NvimTreeGitStaged'] = { fg = t.git_added_fg },
      ['NvimTreeGitNew'] = { fg = t.git_untracked_fg },
      ['NvimTreeGitRenamed'] = { fg = t.git_modified_fg },
      ['NvimTreeGitDeleted'] = { fg = t.git_deleted_fg },
      ['NvimTreeGitMerge'] = { fg = t.git_modified_fg },
      ['NvimTreeGitDirty'] = { fg = t.git_untracked_fg },
      ['NvimTreeSymlink'] = { fg = p.syntax.turquoise },
      ['NvimTreeRootFolder'] = { fg = t.fg, bold = true },
      ['NvimTreeExecFile'] = { fg = '#9FBA89' },
    },
    neo_tree = {
      ['NeoTreeFolderIcon'] = { fg = custom.gold },
      ['NeoTreeIndentMarker'] = { fg = custom.gray },
      ['NeoTreeNormal'] = { fg = t.sidebar_fg, bg = t.sidebar_bg },
      ['NeoTreeFileName'] = { fg = t.sidebar_fg },
      ['NeoTreeFileNameOpened'] = { fg = t.fg, bold = true, italic = true },
      ['NeoTreeDirectoryName'] = { fg = t.sidebar_fg },
      ['NeoTreeDirectoryIcon'] = { fg = custom.gold },
      ['NeoTreeVertSplit'] = { fg = t.sidebar_bg, bg = t.sidebar_bg },
      ['NeoTreeWinSeparator'] = { fg = t.sidebar_bg, bg = t.sidebar_bg },
      ['NeoTreeOpenedFolderName'] = { fg = t.fg, bold = true, italic = true },
      ['NeoTreeEmptyFolderName'] = { fg = t.comment.fg, italic = true },
      ['NeoTreeGitIgnored'] = { fg = t.comment.fg, italic = true },
      ['NeoTreeDotfile'] = { fg = t.comment.fg, italic = true },
      ['NeoTreeHiddenByName'] = { fg = t.comment.fg, italic = true },
      ['NeoTreeEndOfBuffer'] = { fg = t.comment.fg },
      ['NeoTreeCursorLine'] = { bg = t.cursorline_bg },
      ['NeoTreeGitStaged'] = { fg = t.git_added_fg },
      ['NeoTreeGitUntracked'] = { fg = t.git_untracked_fg },
      ['NeoTreeGitDeleted'] = { fg = t.git_deleted_fg },
      ['NeoTreeGitModified'] = { fg = t.git_modified_fg },
      ['NeoTreeSymbolicLinkTarget'] = { fg = p.syntax.turquoise },
      ['NeoTreeRootName'] = { fg = t.fg, bold = true },
      ['NeoTreeTitleBar'] = { fg = p.ui.backgroundAlt, bg = t.fg, bold = true },
    },
    barbar = {
      ['BufferCurrent'] = { fg = t.fg, bg = t.bg },
      ['BufferCurrentIndex'] = { fg = t.fg, bg = t.bg },
      ['BufferCurrentMod'] = { fg = p.ui.warning, bg = t.bg },
      ['BufferCurrentSign'] = { fg = p.ui.accentAlt, bg = t.bg },
      ['BufferCurrentTarget'] = { fg = p.syntax.cranberry, bg = t.bg, bold = true },
      ['BufferVisible'] = { fg = t.fg, bg = t.bg },
      ['BufferVisibleIndex'] = { fg = t.fg, bg = t.bg },
      ['BufferVisibleMod'] = { fg = p.ui.warning, bg = t.bg },
      ['BufferVisibleSign'] = { fg = custom.gray, bg = t.bg },
      ['BufferVisibleTarget'] = { fg = p.syntax.cranberry, bg = t.bg, bold = true },
      ['BufferInactive'] = { fg = custom.gray, bg = p.ui.background },
      ['BufferInactiveIndex'] = { fg = custom.gray, bg = p.ui.background },
      ['BufferInactiveMod'] = { fg = p.ui.warning, bg = p.ui.background },
      ['BufferInactiveSign'] = { fg = custom.gray, bg = p.ui.background },
      ['BufferInactiveTarget'] = { fg = p.syntax.cranberry, bg = p.ui.background, bold = true },
    },
    indent_blankline = {
      ['IndentBlanklineContextChar'] = { fg = t.indent_guide_context_fg, bg = 'NONE' },
      ['IndentBlanklineContextStart'] = { sp = t.indent_guide_context_fg, underline = true },
      ['IndentBlanklineChar'] = { fg = t.indent_guide_fg, bg = 'NONE' },
      ['IndentBlanklineSpaceCharBlankline'] = { fg = t.indent_guide_active_fg },
      ['IndentBlanklineSpaceChar'] = { fg = t.indent_guide_active_fg },
    },
    cmp = {
      ['CmpItemAbbrMatch'] = { fg = t.pmenu_item_sel_fg },
      ['CmpItemAbbrMatchFuzzy'] = { fg = t.pmenu_item_sel_fg, italic = true },
      ['CmpItemAbbrDeprecated'] = { fg = custom.gray, strikethrough = true },
      ['CmpItemKindVariable'] = lsp_kinds['variable'],
      ['CmpItemKindModule'] = lsp_kinds['module'],
      ['CmpItemKindSnippet'] = lsp_kinds['snippet'],
      ['CmpItemKindFolder'] = lsp_kinds['folder'],
      ['CmpItemKindColor'] = lsp_kinds['color'],
      ['CmpItemKindFile'] = lsp_kinds['file'],
      ['CmpItemKindText'] = lsp_kinds['text'],
      ['CmpItemKindMethod'] = lsp_kinds['method'],
      ['CmpItemKindFunction'] = lsp_kinds['function'],
      ['CmpItemKindConstructor'] = lsp_kinds['constructor'],
      ['CmpItemKindField'] = lsp_kinds['field'],
      ['CmpItemKindProperty'] = lsp_kinds['property'],
      ['CmpItemKindUnit'] = lsp_kinds['unit'],
      ['CmpItemKindValue'] = lsp_kinds['value'],
      ['CmpItemKindEnum'] = lsp_kinds['enum'],
      ['CmpItemKindKeyword'] = lsp_kinds['keyword'],
      ['CmpItemKindReference'] = lsp_kinds['reference'],
      ['CmpItemKindConstant'] = lsp_kinds['constant'],
      ['CmpItemKindStruct'] = lsp_kinds['struct'],
      ['CmpItemKindEvent'] = lsp_kinds['event'],
      ['CmpItemKindOperator'] = lsp_kinds['operator'],
      ['CmpItemKindNamespace'] = lsp_kinds['namespace'],
      ['CmpItemKindPackage'] = lsp_kinds['package'],
      ['CmpItemKindString'] = lsp_kinds['string'],
      ['CmpItemKindNumber'] = lsp_kinds['number'],
      ['CmpItemKindBoolean'] = lsp_kinds['boolean'],
      ['CmpItemKindArray'] = lsp_kinds['array'],
      ['CmpItemKindObject'] = lsp_kinds['object'],
      ['CmpItemKindKey'] = lsp_kinds['key'],
      ['CmpItemKindNull'] = lsp_kinds['null'],
      ['CmpItemKindEnumMember'] = lsp_kinds['enumMember'],
      ['CmpItemKindClass'] = lsp_kinds['class'],
      ['CmpItemKindInterface'] = lsp_kinds['interface'],
      ['CmpItemKindTypeParameter'] = lsp_kinds['typeParameter'],
    },
    navic = {
      ['NavicIconsFile'] = lsp_kinds['file'],
      ['NavicIconsModule'] = lsp_kinds['module'],
      ['NavicIconsNamespace'] = lsp_kinds['namespace'],
      ['NavicIconsPackage'] = lsp_kinds['package'],
      ['NavicIconsClass'] = lsp_kinds['class'],
      ['NavicIconsMethod'] = lsp_kinds['method'],
      ['NavicIconsProperty'] = lsp_kinds['property'],
      ['NavicIconsField'] = lsp_kinds['field'],
      ['NavicIconsConstructor'] = lsp_kinds['constructor'],
      ['NavicIconsEnum'] = lsp_kinds['enum'],
      ['NavicIconsInterface'] = lsp_kinds['interface'],
      ['NavicIconsFunction'] = lsp_kinds['function'],
      ['NavicIconsVariable'] = lsp_kinds['variable'],
      ['NavicIconsConstant'] = lsp_kinds['constant'],
      ['NavicIconsString'] = lsp_kinds['string'],
      ['NavicIconsNumber'] = lsp_kinds['number'],
      ['NavicIconsBoolean'] = lsp_kinds['boolean'],
      ['NavicIconsArray'] = lsp_kinds['array'],
      ['NavicIconsObject'] = lsp_kinds['object'],
      ['NavicIconsKey'] = lsp_kinds['key'],
      ['NavicIconsKeyword'] = lsp_kinds['keyword'],
      ['NavicIconsNull'] = lsp_kinds['null'],
      ['NavicIconsEnumMember'] = lsp_kinds['enumMember'],
      ['NavicIconsStruct'] = lsp_kinds['struct'],
      ['NavicIconsEvent'] = lsp_kinds['event'],
      ['NavicIconsOperator'] = lsp_kinds['operator'],
      ['NavicIconsTypeParameter'] = lsp_kinds['typeParameter'],
      ['NavicText'] = { fg = t.fg },
      ['NavicSeparator'] = { fg = t.fg },
    },
    packer = {
      ['packerString'] = { fg = custom.gold },
      ['packerHash'] = { fg = p.ansi.normal.blue },
      ['packerOutput'] = { fg = custom.purple1 },
      ['packerRelDate'] = { fg = custom.gray },
      ['packerSuccess'] = { fg = p.ui.positive },
      ['packerStatusSuccess'] = { fg = p.ansi.normal.blue },
    },
    symbols_outline = {
      ['SymbolsOutlineConnector'] = { fg = custom.gray },
      ['FocusedSymbol'] = { bg = '#36383F' },
    },
    notify = {
      ['NotifyERRORBorder'] = { fg = tint(custom.error, -0.6) },
      ['NotifyWARNBorder'] = { fg = tint(custom.warn, -0.4) },
      ['NotifyINFOBorder'] = { fg = tint(custom.info, -0.4) },
      ['NotifyDEBUGBorder'] = { fg = tint(custom.hint, -0.4) },
      ['NotifyTRACEBorder'] = { fg = t.float_border },
      ['NotifyERRORIcon'] = { fg = custom.error },
      ['NotifyWARNIcon'] = { fg = custom.warn },
      ['NotifyINFOIcon'] = { fg = custom.info },
      ['NotifyDEBUGIcon'] = { fg = custom.hint },
      ['NotifyTRACEIcon'] = { fg = t.float_border },
      ['NotifyERRORTitle'] = { fg = custom.error },
      ['NotifyWARNTitle'] = { fg = custom.warn },
      ['NotifyINFOTitle'] = { fg = custom.info },
      ['NotifyDEBUGTitle'] = { fg = custom.hint },
      ['NotifyTRACETitle'] = { fg = t.float_border },
    },
    rainbow_delimiter = {
      ['RainbowDelimiterGreen'] = { fg = p.ansi.normal.green },
      ['RainbowDelimiterCyan'] = { fg = p.syntax.turquoise },
      ['RainbowDelimiterOrange'] = { fg = t.constant.fg },
      ['RainbowDelimiterRed'] = { fg = t.variable.fg },
      ['RainbowDelimiterYellow'] = { fg = t.type.fg }, --[['#FFD602']]
      ['RainbowDelimiterViolet'] = { fg = t.keyword.fg }, -- [['#DA70D6']]
      ['RainbowDelimiterBlue'] = { fg = '#169FFF' },
    },
    ts_rainbow = {
      ['TSRainbowGreen'] = { fg = p.ansi.normal.green },
      ['TSRainbowCyan'] = { fg = p.syntax.turquoise },
      ['TSRainbowOrange'] = { fg = t.constant.fg },
      ['TSRainbowRed'] = { fg = t.variable.fg },
      ['TSRainbowYellow'] = { fg = t.type.fg }, --[['#FFD602']]
      ['TSRainbowViolet'] = { fg = t.keyword.fg }, -- [['#DA70D6']]
      ['TSRainbowBlue'] = { fg = '#169FFF' },
    },
    hop = {
      ['HopNextKey'] = { fg = '#4ae0ff' },
      ['HopNextKey1'] = { fg = '#d44eed' },
      ['HopNextKey2'] = { fg = '#b42ecd' },
      ['HopPreview'] = { fg = '#c7ba7d' },
      ['HopUnmatched'] = { fg = custom.gray },
    },
    flash = {
      ['FlashLabel'] = { fg = '#4ae0ff', bold = true, italic = true },
      ['FlashCurrent'] = { fg = '#d44eed', underline = true },
      ['FlashMatch'] = { fg = '#b42ecd' },
      ['FlashBackdrop'] = { fg = custom.gray },
    },
    crates = {
      ['CratesNvimLoading'] = { fg = p.ui.accentAlt },
      ['CratesNvimVersion'] = { fg = p.ui.accentAlt },
    },
  }
end

---Add in any enabled plugin's custom highlighting
---@param config horizon.Config
---@param plugins {[string]: horizon.Opts}
---@param highlights {[string]: horizon.Opts}
local function integrate_plugins(config, plugins, highlights)
  for plugin, enabled in pairs(config.plugins) do
    if enabled and plugins[plugin] then
      for key, value in pairs(plugins[plugin]) do
        highlights[key] = value
      end
    end
  end
  return highlights
end

---@param config horizon.Config
function M.set_highlights(config)
  local bg = vim.o.background
  local data = require(('horizon.palette-%s'):format(bg)) ---@module 'horizon.palette-dark'
  local custom = get_custom_highlights(data)
  local highlights = integrate_plugins(config, get_plugin_highlights(data, custom), get_highlights(data, custom))
  if config.overrides.colors then vim.tbl_extend('force', highlights, config.overrides.colors) end
  for name, value in pairs(highlights) do
    vim.api.nvim_set_hl(0, name, value)
  end
end

return M
