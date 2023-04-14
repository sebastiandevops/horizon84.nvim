local c = require('horizon.palette')

---@class horizon.Opts
---@field fg string
---@field bg string
---@field sp string
---@field bold boolean
---@field italic boolean
---@field underline boolean
---@field undercurl boolean
---@field reverse boolean
---@field standout boolean
---@field link string

---@alias horizon.HighlightDef {[string]: horizon.Opts}[]
---@alias Theme 'light' | 'dark'

local api = vim.api

local M = {}

local function get_lsp_kind_highlights()
  return {
    -- LSP Kind Items
    ['module'] = { fg = c.yelloworange, bg = 'NONE' },
    ['snippet'] = { fg = c.purple, bg = 'NONE' },
    ['folder'] = { fg = 'fg', bg = 'NONE' },
    ['color'] = { fg = 'fg', bg = 'NONE' },
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

---@param bg Theme
---@return horizon.HighlightDef
local function get_highlights(bg)
  ---@module 'horizon.palette-dark'
  local theme = require(('horizon.palette-%s'):format(bg))
  return {
    -- Editor
    { ['Normal'] = { fg = theme.fg, bg = theme.bg } },
    { ['NormalNC'] = { fg = theme.fg, bg = theme.bg } },
    { ['SignColumn'] = { fg = 'NONE', bg = 'NONE' } },
    { ['MsgArea'] = { fg = theme.fg, bg = theme.bg } },
    { ['ModeMsg'] = { fg = theme.fg, bg = c.alt_bg } },
    { ['MsgSeparator'] = { fg = theme.winseparator_fg, bg = theme.bg } },
    { ['SpellBad'] = { fg = 'NONE', bg = 'NONE', sp = c.red, undercurl = true } },
    { ['SpellCap'] = { fg = 'NONE', bg = 'NONE', sp = c.yellow, undercurl = true } },
    { ['SpellLocal'] = { fg = 'NONE', bg = 'NONE', sp = c.yelloworange, underline = true } },
    { ['SpellRare'] = { fg = 'NONE', bg = 'NONE', sp = c.purple, underline = true } },
    { ['Pmenu'] = { fg = theme.fg, bg = theme.pmenu_bg } },
    { ['PmenuSel'] = { fg = 'NONE', bg = c.ui2_blue } },
    { ['PmenuSbar'] = { fg = 'NONE', bg = theme.pmenu_thumb_bg } },
    { ['PmenuThumb'] = { fg = 'NONE', bg = theme.pmenu_thumb_fg } },
    { ['WildMenu'] = { fg = theme.fg, bg = c.ui2_blue } },
    { ['CursorLineNr'] = { fg = theme.active_line_number_fg, bg = 'NONE', bold = true } },
    { ['Folded'] = { fg = c.gray, bg = c.alt_bg } },
    { ['FoldColumn'] = { fg = c.gray, bg = c.alt_bg } },
    { ['LineNr'] = { fg = theme.inactive_line_number_fg, bg = 'NONE' } },
    { ['FloatBorder'] = { fg = c.gray, bg = c.alt_bg } },
    { ['Whitespace'] = { fg = c.pale_grey, bg = 'NONE' } },
    { ['VertSplit'] = { fg = theme.winseparator_fg, bg = theme.bg } },
    { ['CursorLine'] = { fg = 'NONE', bg = theme.cursorline_bg } },
    { ['CursorColumn'] = { fg = 'NONE', bg = c.alt_bg } },
    { ['ColorColumn'] = { fg = 'NONE', bg = c.alt_bg } },
    { ['NormalFloat'] = { fg = 'NONE', bg = c.alt_bg } },
    { ['Visual'] = { fg = 'NONE', bg = c.ui_blue } },
    { ['VisualNOS'] = { fg = 'NONE', bg = c.alt_bg } },
    { ['WarningMsg'] = { fg = c.error, bg = theme.bg } },
    { ['DiffText'] = { fg = c.alt_bg, bg = theme.diff_deleted_bg } },
    { ['DiffAdd'] = { fg = c.alt_bg, bg = theme.diff_added_bg } },
    { ['DiffDelete'] = { fg = c.alt_bg, bg = theme.diff_deleted_bg } },
    { ['DiffChange'] = { fg = c.alt_bg, bg = c.sign_change, underline = true } },
    { ['QuickFixLine'] = { fg = 'NONE', bg = c.ui2_blue } },
    { ['MatchParen'] = { fg = theme.match_paren, bg = 'NONE', underline = true } },
    { ['Cursor'] = { fg = theme.cursor_fg, bg = theme.cursor_bg } },
    { ['lCursor'] = { fg = theme.cursor_fg, bg = theme.cursor_bg } },
    { ['CursorIM'] = { fg = theme.cursor_fg, bg = theme.cursor_bg } },
    { ['TermCursor'] = { fg = theme.term_cursor_fg, bg = theme.term_cursor_bg } },
    { ['TermCursorNC'] = { fg = theme.term_cursor_fg, bg = theme.term_cursor_bg } },
    { ['Conceal'] = { fg = c.gray, bg = 'NONE' } },
    { ['Directory'] = { fg = c.folder_blue, bg = 'NONE' } },
    { ['SpecialKey'] = { fg = c.red, bg = 'NONE', bold = true } },
    { ['ErrorMsg'] = { fg = c.error, bg = theme.bg, bold = true } },
    { ['Search'] = { fg = 'NONE', bg = c.ui2_blue } },
    { ['IncSearch'] = { fg = 'NONE', bg = c.ui2_blue } },
    { ['Substitute'] = { fg = 'NONE', bg = c.ui2_blue } },
    { ['MoreMsg'] = { fg = c.orange, bg = 'NONE' } },
    { ['Question'] = { fg = c.orange, bg = 'NONE' } },
    { ['EndOfBuffer'] = { fg = theme.bg, bg = 'NONE' } },
    { ['NonText'] = { fg = theme.bg, bg = 'NONE' } },
    { ['TabLine'] = { fg = c.light_gray, bg = c.line } },
    { ['TabLineSel'] = { fg = theme.fg, bg = c.line } },
    { ['TabLineFill'] = { fg = c.line, bg = c.line } },

    -- Code
    { ['Comment'] = theme.comment },
    { ['Variable'] = { fg = c.red, bg = 'NONE' } },
    { ['String'] = theme.string },
    { ['Character'] = { fg = c.yelloworange, bg = 'NONE' } },
    { ['Number'] = { fg = c.orange, bg = 'NONE' } },
    { ['Float'] = { fg = c.orange, bg = 'NONE' } },
    { ['Boolean'] = { fg = c.orange, bg = 'NONE' } },
    { ['Constant'] = theme.constant },
    { ['Type'] = { fg = c.yellow, bg = 'NONE' } },
    { ['Function'] = theme.func },
    { ['Keyword'] = theme.keyword },
    { ['Conditional'] = { fg = c.purple, bg = 'NONE' } },
    { ['Repeat'] = { fg = c.purple, bg = 'NONE' } },
    { ['Operator'] = theme.operator },
    { ['PreProc'] = { fg = c.purple, bg = 'NONE' } },
    { ['Include'] = { fg = c.purple, bg = 'NONE' } },
    { ['Exception'] = { fg = c.purple, bg = 'NONE' } },
    { ['StorageClass'] = { fg = c.yellow, bg = 'NONE' } },
    { ['Structure'] = { fg = c.yellow, bg = 'NONE' } },
    { ['Typedef'] = { fg = c.purple, bg = 'NONE' } },
    { ['Define'] = { fg = c.purple, bg = 'NONE' } },
    { ['Macro'] = { fg = c.purple, bg = 'NONE' } },
    { ['Debug'] = { fg = c.red, bg = 'NONE' } },
    { ['Title'] = { fg = c.yellow, bg = 'NONE', bold = true } },
    { ['Label'] = { fg = c.red, bg = 'NONE' } },
    { ['SpecialChar'] = { fg = c.yelloworange, bg = 'NONE' } },
    { ['Delimiter'] = { fg = c.alt_fg, bg = 'NONE' } },
    { ['SpecialComment'] = { fg = theme.fg, bg = 'NONE' } },
    { ['Tag'] = { fg = c.red, bg = 'NONE' } },
    { ['Bold'] = { fg = 'NONE', bg = 'NONE', bold = true } },
    { ['Italic'] = { fg = 'NONE', bg = 'NONE', italic = true } },
    { ['Underlined'] = { fg = 'NONE', bg = 'NONE', underline = true } },
    { ['Ignore'] = { fg = c.hint, bg = 'NONE', bold = true } },
    { ['Todo'] = { fg = c.info, bg = 'NONE', bold = true } },
    { ['Error'] = { fg = c.error, bg = 'NONE', bold = true } },
    { ['Statement'] = { fg = c.purple, bg = 'NONE' } },
    { ['Identifier'] = { fg = theme.fg, bg = 'NONE' } },
    { ['PreCondit'] = { fg = c.purple, bg = 'NONE' } },
    { ['Special'] = { fg = c.orange, bg = 'NONE' } },

    -- Treesitter
    { ['@comment'] = { link = 'Comment' } },
    { ['@variable'] = { link = 'Variable' } },
    { ['@string'] = { link = 'String' } },
    { ['@string.regex'] = { link = 'String' } },
    { ['@string.escape'] = { link = 'String' } },
    { ['@character'] = { link = 'String' } },
    { ['@character.special'] = { link = 'SpecialChar' } },
    { ['@number'] = { link = 'Number' } },
    { ['@float'] = { link = 'Float' } },
    { ['@boolean'] = { link = 'Boolean' } },
    { ['@constant'] = { link = 'Constant' } },
    { ['@constant.builtin'] = { link = 'Constant' } },
    { ['@constructor'] = { link = 'Type' } },
    { ['@type'] = { link = 'Type' } },
    { ['@include'] = { link = 'Include' } },
    { ['@exception'] = { link = 'Exception' } },
    { ['@keyword'] = { link = 'Keyword' } },
    { ['@keyword.return'] = { link = 'Keyword' } },
    { ['@keyword.operator'] = { link = 'Keyword' } },
    { ['@keyword.function'] = { link = 'Keyword' } },
    { ['@function'] = { link = 'Function' } },
    { ['@function.builtin'] = { link = 'Function' } },
    { ['@method'] = { link = 'Function' } },
    { ['@function.macro'] = { link = 'Function' } },
    { ['@conditional'] = { link = 'Conditional' } },
    { ['@repeat'] = { link = 'Repeat' } },
    { ['@operator'] = { link = 'Operator' } },
    { ['@preproc'] = { link = 'PreProc' } },
    { ['@storageclass'] = { link = 'StorageClass' } },
    { ['@structure'] = { link = 'Structure' } },
    { ['@type.definition'] = { link = 'Typedef' } },
    { ['@define'] = { link = 'Define' } },
    { ['@note'] = { link = 'Comment' } },
    { ['@none'] = { fg = c.light_gray, bg = 'NONE' } },
    { ['@todo'] = { link = 'Todo' } },
    { ['@debug'] = { link = 'Debug' } },
    { ['@danger'] = { link = 'Error' } },
    { ['@title'] = { link = 'Title' } },
    { ['@label'] = { link = 'Label' } },
    { ['@tag.delimiter'] = { fg = c.red, bg = 'NONE' } },
    { ['@punctuation.delimiter'] = { link = 'Delimiter' } },
    { ['@punctuation.bracket'] = { link = 'Delimiter' } },
    { ['@punctuation.special'] = { link = 'Delimiter' } },
    { ['@tag'] = { link = 'Tag' } },
    { ['@strong'] = { link = 'Bold' } },
    { ['@emphasis'] = { link = 'Italic' } },
    { ['@underline'] = { link = 'Underline' } },
    { ['@strike'] = { fg = 'NONE', bg = 'NONE', strikethrough = true } },
    { ['@string.special'] = { fg = theme.fg, bg = 'NONE' } },
    { ['@environment.name'] = { fg = c.cyan, bg = 'NONE' } },
    { ['@variable.builtin'] = { fg = c.yellow, bg = 'NONE' } },
    { ['@const.macro'] = { fg = c.orange, bg = 'NONE' } },
    { ['@type.builtin'] = { fg = c.orange, bg = 'NONE' } },
    { ['@annotation'] = { fg = c.cyan, bg = 'NONE' } },
    { ['@namespace'] = { fg = c.cyan, bg = 'NONE' } },
    { ['@symbol'] = { fg = theme.fg, bg = 'NONE' } },
    { ['@field'] = { fg = c.red, bg = 'NONE' } },
    { ['@property'] = { fg = c.red, bg = 'NONE' } },
    { ['@parameter'] = { fg = c.red, bg = 'NONE' } },
    { ['@parameter.reference'] = theme.parameter },
    { ['@attribute'] = { fg = c.red, bg = 'NONE' } },
    { ['@text'] = { fg = c.alt_fg, bg = 'NONE' } },
    { ['@tag.attribute'] = { fg = c.orange, bg = 'NONE', italic = true } },
    { ['@error'] = { fg = theme.error, bg = 'NONE' } },
    { ['@warning'] = { fg = theme.warning, bg = 'NONE' } },
    { ['@query.linter.error'] = { fg = c.error, bg = 'NONE' } },
    { ['@uri'] = { fg = c.cyan, bg = 'NONE', underline = true } },
    { ['@math'] = { fg = c.yellow, bg = 'NONE' } },

    -- LspSemanticTokens
    { ['@lsp.type.namespace'] = { link = '@namespace' } },
    { ['@lsp.type.type'] = { link = '@type' } },
    { ['@lsp.type.class'] = { link = '@type' } },
    { ['@lsp.type.enum'] = { link = '@type' } },
    { ['@lsp.type.interface'] = { link = '@type' } },
    { ['@lsp.type.struct'] = { link = '@structure' } },
    { ['@lsp.type.typeParameter'] = { link = 'TypeDef' } },
    { ['@lsp.type.variable'] = { link = '@variable' } },
    { ['@lsp.type.property'] = { link = '@property' } },
    { ['@lsp.type.enumMember'] = { link = '@constant' } },
    { ['@lsp.type.function'] = { link = '@function' } },
    { ['@lsp.type.method'] = { link = '@method' } },
    { ['@lsp.type.macro'] = { link = '@macro' } },
    { ['@lsp.type.decorator'] = { link = '@function' } },
    { ['@lsp.typemod.variable.readonly'] = { link = '@constant' } },
    { ['@lsp.typemod.method.defaultLibrary'] = { link = '@function.builtin' } },
    { ['@lsp.typemod.function.defaultLibrary'] = { link = '@function.builtin' } },
    { ['@lsp.typemod.variable.defaultLibrary'] = { link = '@variable.builtin' } },
    { ['@lsp.mod.deprecated'] = { fg = 'NONE', bg = 'NONE', strikethrough = true } },

    -- LSP
    { ['DiagnosticHint'] = { fg = c.hint, bg = 'NONE' } },
    { ['DiagnosticInfo'] = { fg = c.info, bg = 'NONE' } },
    { ['DiagnosticWarn'] = { fg = c.warn, bg = 'NONE' } },
    { ['DiagnosticError'] = { fg = c.error, bg = 'NONE' } },
    { ['DiagnosticOther'] = { fg = c.ui_purple, bg = 'NONE' } },
    { ['DiagnosticSignHint'] = { link = 'DiagnosticHint' } },
    { ['DiagnosticSignInfo'] = { link = 'DiagnosticInfo' } },
    { ['DiagnosticSignWarn'] = { link = 'DiagnosticWarn' } },
    { ['DiagnosticSignError'] = { link = 'DiagnosticError' } },
    { ['DiagnosticSignOther'] = { link = 'DiagnosticOther' } },
    { ['DiagnosticSignWarning'] = { link = 'DiagnosticWarn' } },
    { ['DiagnosticFloatingHint'] = { link = 'DiagnosticHint' } },
    { ['DiagnosticFloatingInfo'] = { link = 'DiagnosticInfo' } },
    { ['DiagnosticFloatingWarn'] = { link = 'DiagnosticWarn' } },
    { ['DiagnosticFloatingError'] = { link = 'DiagnosticError' } },
    { ['DiagnosticUnderlineHint'] = { fg = 'NONE', bg = 'NONE', sp = c.hint, undercurl = true } },
    { ['DiagnosticUnderlineInfo'] = { fg = 'NONE', bg = 'NONE', sp = c.info, undercurl = true } },
    { ['DiagnosticUnderlineWarn'] = { fg = 'NONE', bg = 'NONE', sp = c.warn, undercurl = true } },
    { ['DiagnosticUnderlineError'] = { fg = 'NONE', bg = 'NONE', sp = c.error, undercurl = true } },
    { ['DiagnosticSignInformation'] = { link = 'DiagnosticInfo' } },
    { ['DiagnosticVirtualTextHint'] = { fg = c.hint, bg = c.hint_bg } },
    { ['DiagnosticVirtualTextInfo'] = { fg = c.info, bg = c.info_bg } },
    { ['DiagnosticVirtualTextWarn'] = { fg = c.warn, bg = c.warn_bg } },
    { ['DiagnosticVirtualTextError'] = { fg = c.error, bg = c.error_bg } },
    { ['LspDiagnosticsError'] = { fg = c.error, bg = 'NONE' } },
    { ['LspDiagnosticsWarning'] = { fg = c.warn, bg = 'NONE' } },
    { ['LspDiagnosticsInfo'] = { fg = c.info, bg = 'NONE' } },
    { ['LspDiagnosticsInformation'] = { link = 'LspDiagnosticsInfo' } },
    { ['LspDiagnosticsHint'] = { fg = c.hint, bg = 'NONE' } },
    { ['LspDiagnosticsDefaultError'] = { link = 'LspDiagnosticsError' } },
    { ['LspDiagnosticsDefaultWarning'] = { link = 'LspDiagnosticsWarning' } },
    { ['LspDiagnosticsDefaultInformation'] = { link = 'LspDiagnosticsInfo' } },
    { ['LspDiagnosticsDefaultInfo'] = { link = 'LspDiagnosticsInfo' } },
    { ['LspDiagnosticsDefaultHint'] = { link = 'LspDiagnosticsHint' } },
    { ['LspDiagnosticsVirtualTextError'] = { link = 'DiagnosticVirtualTextError' } },
    { ['LspDiagnosticsVirtualTextWarning'] = { link = 'DiagnosticVirtualTextWarn' } },
    { ['LspDiagnosticsVirtualTextInformation'] = { link = 'DiagnosticVirtualTextInfo' } },
    { ['LspDiagnosticsVirtualTextInfo'] = { link = 'DiagnosticVirtualTextInfo' } },
    { ['LspDiagnosticsVirtualTextHint'] = { link = 'DiagnosticVirtualTextHint' } },
    { ['LspDiagnosticsFloatingError'] = { link = 'LspDiagnosticsError' } },
    { ['LspDiagnosticsFloatingWarning'] = { link = 'LspDiagnosticsWarning' } },
    { ['LspDiagnosticsFloatingInformation'] = { link = 'LspDiagnosticsInfo' } },
    { ['LspDiagnosticsFloatingInfo'] = { link = 'LspDiagnosticsInfo' } },
    { ['LspDiagnosticsFloatingHint'] = { link = 'LspDiagnosticsHint' } },
    { ['LspDiagnosticsSignError'] = { link = 'LspDiagnosticsError' } },
    { ['LspDiagnosticsSignWarning'] = { link = 'LspDiagnosticsWarning' } },
    { ['LspDiagnosticsSignInformation'] = { link = 'LspDiagnosticsInfo' } },
    { ['LspDiagnosticsSignInfo'] = { link = 'LspDiagnosticsInfo' } },
    { ['LspDiagnosticsSignHint'] = { link = 'LspDiagnosticsHint' } },
    { ['NvimTreeLspDiagnosticsError'] = { link = 'LspDiagnosticsError' } },
    { ['NvimTreeLspDiagnosticsWarning'] = { link = 'LspDiagnosticsWarning' } },
    { ['NvimTreeLspDiagnosticsInformation'] = { link = 'LspDiagnosticsInfo' } },
    { ['NvimTreeLspDiagnosticsInfo'] = { link = 'LspDiagnosticsInfo' } },
    { ['NvimTreeLspDiagnosticsHint'] = { link = 'LspDiagnosticsHint' } },
    { ['LspDiagnosticsUnderlineError'] = { link = 'DiagnosticUnderlineError' } },
    { ['LspDiagnosticsUnderlineWarning'] = { link = 'DiagnosticUnderlineWarn' } },
    { ['LspDiagnosticsUnderlineInformation'] = { link = 'DiagnosticUnderlineInfo' } },
    { ['LspDiagnosticsUnderlineInfo'] = { link = 'DiagnosticUnderlineInfo' } },
    { ['LspDiagnosticsUnderlineHint'] = { link = 'DiagnosticUnderlineHint' } },
    { ['LspReferenceRead'] = { fg = 'NONE', bg = c.reference } },
    { ['LspReferenceText'] = { fg = 'NONE', bg = c.reference } },
    { ['LspReferenceWrite'] = { fg = 'NONE', bg = c.reference } },
    { ['LspCodeLens'] = { fg = theme.codelens_fg, bg = 'NONE', italic = true } },
    { ['LspCodeLensSeparator'] = { fg = theme.codelens_fg, bg = 'NONE', italic = true } },

    -- StatusLine
    { ['StatusLine'] = { fg = theme.statusline_fg, bg = theme.statusline_bg } },
    { ['StatusLineNC'] = { fg = c.line, bg = theme.bg } },
    { ['StatusLineSeparator'] = { fg = c.line, bg = 'NONE' } },
    { ['StatusLineTerm'] = { fg = c.line, bg = 'NONE' } },
    { ['StatusLineTermNC'] = { fg = c.line, bg = 'NONE' } },
  }
end

---@param bg Theme
---@return horizon.HighlightDef
local function get_plugin_highlights(bg)
  ---@module 'horizon.palette-dark'
  local theme = require(('horizon.palette-%s'):format(bg))
  local lsp_kinds = get_lsp_kind_highlights()
  return {
    whichkey = {
      { ['WhichKey'] = { fg = c.purple, bg = 'NONE' } },
      { ['WhichKeySeperator'] = { fg = c.yellow, bg = 'NONE' } },
      { ['WhichKeyGroup'] = { fg = c.red, bg = 'NONE' } },
      { ['WhichKeyDesc'] = { fg = theme.fg, bg = 'NONE' } },
      { ['WhichKeyFloat'] = { fg = 'NONE', bg = c.alt_bg } },
    },
    gitsigns = {
      { ['SignAdd'] = { fg = theme.git_added_fg, bg = 'NONE' } },
      { ['SignChange'] = { fg = theme.git_modified_fg, bg = 'NONE' } },
      { ['SignDelete'] = { fg = theme.git_deleted_fg, bg = 'NONE' } },
      { ['GitSignsAdd'] = { fg = theme.git_added_fg, bg = 'NONE' } },
      { ['GitSignsChange'] = { fg = theme.git_added_fg, bg = 'NONE' } },
      { ['GitSignsDelete'] = { fg = theme.git_deleted_fg, bg = 'NONE' } },
      { ['GitSignsUntracked'] = { fg = theme.git_untracked_fg, bg = 'NONE' } },
    },
    quickscope = {
      { ['QuickScopePrimary'] = { fg = '#ff007c', bg = 'NONE', underline = true } },
      { ['QuickScopeSecondary'] = { fg = '#00dfff', bg = 'NONE', underline = true } },
    },
    telescope = {
      { ['TelescopeSelection'] = { fg = 'NONE', bg = c.ui2_blue } },
      { ['TelescopeSelectionCaret'] = { fg = c.red, bg = c.ui2_blue } },
      { ['TelescopeMatching'] = { fg = c.yellow, bg = 'NONE', bold = true, italic = true } },
      { ['TelescopeBorder'] = { fg = c.alt_fg, bg = 'NONE' } },
      { ['TelescopeNormal'] = { fg = c.light_gray, bg = c.alt_bg } },
      { ['TelescopePromptTitle'] = { fg = c.orange, bg = 'NONE' } },
      { ['TelescopePromptPrefix'] = { fg = c.cyan, bg = 'NONE' } },
      { ['TelescopeResultsTitle'] = { fg = c.orange, bg = 'NONE' } },
      { ['TelescopePreviewTitle'] = { fg = c.orange, bg = 'NONE' } },
      { ['TelescopePromptCounter'] = { fg = c.red, bg = 'NONE' } },
      { ['TelescopePreviewHyphen'] = { fg = c.red, bg = 'NONE' } },
    },
    nvim_tree = {
      { ['NvimTreeFolderIcon'] = { fg = theme.fg, bg = 'NONE' } },
      { ['NvimTreeIndentMarker'] = { fg = c.light_gray, bg = 'NONE' } },
      { ['NvimTreeNormal'] = { fg = theme.fg, bg = c.alt_bg } },
      { ['NvimTreeVertSplit'] = { fg = c.alt_bg, bg = c.alt_bg } },
      { ['NvimTreeFolderName'] = { fg = theme.fg, bg = 'NONE' } },
      { ['NvimTreeOpenedFolderName'] = { fg = theme.fg, bg = 'NONE', bold = true, italic = true } },
      { ['NvimTreeEmptyFolderName'] = { fg = c.gray, bg = 'NONE', italic = true } },
      { ['NvimTreeGitIgnored'] = { fg = c.gray, bg = 'NONE', italic = true } },
      { ['NvimTreeImageFile'] = { fg = c.light_gray, bg = 'NONE' } },
      { ['NvimTreeSpecialFile'] = { fg = c.orange, bg = 'NONE' } },
      { ['NvimTreeEndOfBuffer'] = { fg = c.alt_bg, bg = 'NONE' } },
      { ['NvimTreeCursorLine'] = { fg = 'NONE', bg = c.dark_gray } },
      { ['NvimTreeGitStaged'] = { fg = c.sign_add_alt, bg = 'NONE' } },
      { ['NvimTreeGitNew'] = { fg = c.sign_add_alt, bg = 'NONE' } },
      { ['NvimTreeGitRenamed'] = { fg = c.sign_add_alt, bg = 'NONE' } },
      { ['NvimTreeGitDeleted'] = { fg = c.sign_delete, bg = 'NONE' } },
      { ['NvimTreeGitMerge'] = { fg = c.sign_change_alt, bg = 'NONE' } },
      { ['NvimTreeGitDirty'] = { fg = c.sign_change_alt, bg = 'NONE' } },
      { ['NvimTreeSymlink'] = { fg = c.cyan, bg = 'NONE' } },
      { ['NvimTreeRootFolder'] = { fg = theme.fg, bg = 'NONE', bold = true } },
      { ['NvimTreeExecFile'] = { fg = '#9FBA89', bg = 'NONE' } },
    },
    neo_tree = {
      { ['NeoTreeFolderIcon'] = { fg = theme.fg, bg = 'NONE' } },
      { ['NeoTreeIndentMarker'] = { fg = c.gray, bg = 'NONE' } },
      { ['NeoTreeNormal'] = { fg = theme.sidebar_fg, bg = theme.sidebar_bg } },
      { ['NeoTreeVertSplit'] = { fg = c.alt_bg, bg = c.alt_bg } },
      { ['NeoTreeWinSeparator'] = { fg = c.alt_bg, bg = c.alt_bg } },
      { ['NeoTreeDirectoryName'] = { fg = theme.fg, bg = 'NONE' } },
      { ['NeoTreeDirectoryIcon'] = { fg = theme.fg, bg = 'NONE' } },
      { ['NeoTreeFileName'] = { fg = c.light_gray, bg = 'NONE' } },
      { ['NeoTreeOpenedFolderName'] = { fg = theme.fg, bg = 'NONE', bold = true, italic = true } },
      { ['NeoTreeEmptyFolderName'] = { fg = c.gray, bg = 'NONE', italic = true } },
      { ['NeoTreeGitIgnored'] = { fg = c.gray, bg = 'NONE', italic = true } },
      { ['NeoTreeDotfile'] = { fg = c.gray, bg = 'NONE', italic = true } },
      { ['NeoTreeHiddenByName'] = { fg = c.gray, bg = 'NONE', italic = true } },
      { ['NeoTreeEndOfBuffer'] = { fg = c.alt_bg, bg = 'NONE' } },
      { ['NeoTreeCursorLine'] = { fg = 'NONE', bg = c.dark_gray } },
      { ['NeoTreeGitStaged'] = { fg = c.sign_add_alt, bg = 'NONE' } },
      { ['NeoTreeGitUntracked'] = { fg = c.sign_add_alt, bg = 'NONE' } },
      { ['NeoTreeGitDeleted'] = { fg = c.sign_delete, bg = 'NONE' } },
      { ['NeoTreeGitModified'] = { fg = c.sign_change_alt, bg = 'NONE' } },
      { ['NeoTreeSymbolicLinkTarget'] = { fg = c.cyan, bg = 'NONE' } },
      { ['NeoTreeRootName'] = { fg = theme.fg, bg = 'NONE', bold = true } },
      { ['NeoTreeTitleBar'] = { fg = c.dark_gray, bg = theme.fg, bold = true } },
    },
    barbar = {
      { ['BufferCurrent'] = { fg = theme.fg, bg = theme.bg } },
      { ['BufferCurrentIndex'] = { fg = theme.fg, bg = theme.bg } },
      { ['BufferCurrentMod'] = { fg = c.info, bg = theme.bg } },
      { ['BufferCurrentSign'] = { fg = c.hint, bg = theme.bg } },
      { ['BufferCurrentTarget'] = { fg = c.red, bg = theme.bg, bold = true } },
      { ['BufferVisible'] = { fg = theme.fg, bg = theme.bg } },
      { ['BufferVisibleIndex'] = { fg = theme.fg, bg = theme.bg } },
      { ['BufferVisibleMod'] = { fg = c.info, bg = theme.bg } },
      { ['BufferVisibleSign'] = { fg = c.gray, bg = theme.bg } },
      { ['BufferVisibleTarget'] = { fg = c.red, bg = theme.bg, bold = true } },
      { ['BufferInactive'] = { fg = c.gray, bg = c.alt_bg } },
      { ['BufferInactiveIndex'] = { fg = c.gray, bg = c.alt_bg } },
      { ['BufferInactiveMod'] = { fg = c.info, bg = c.alt_bg } },
      { ['BufferInactiveSign'] = { fg = c.gray, bg = c.alt_bg } },
      { ['BufferInactiveTarget'] = { fg = c.red, bg = c.alt_bg, bold = true } },
    },
    indent_blankline = {
      { ['IndentBlanklineContextChar'] = { fg = theme.indent_guide_active_fg, bg = 'NONE' } },
      { ['IndentBlanklineContextStart'] = { sp = theme.indent_guide_active_fg, underline = true } },
      { ['IndentBlanklineChar'] = { fg = theme.indent_guide_fg, bg = 'NONE' } },
    },
    cmp = {
      { ['CmpItemAbbrMatch'] = { fg = theme.pmenu_item_sel_fg } },
      { ['CmpItemAbbrMatchFuzzy'] = { fg = theme.pmenu_item_sel_fg, italic = true } },
      { ['CmpItemAbbrDeprecated'] = { fg = c.gray, strikethrough = true } },
      { ['CmpItemKindVariable'] = lsp_kinds['variable'] },
      { ['CmpItemKindModule'] = lsp_kinds['module'] },
      { ['CmpItemKindSnippet'] = lsp_kinds['snippet'] },
      { ['CmpItemKindFolder'] = lsp_kinds['folder'] },
      { ['CmpItemKindColor'] = lsp_kinds['color'] },
      { ['CmpItemKindFile'] = lsp_kinds['file'] },
      { ['CmpItemKindText'] = lsp_kinds['text'] },
      { ['CmpItemKindMethod'] = lsp_kinds['method'] },
      { ['CmpItemKindFunction'] = lsp_kinds['function'] },
      { ['CmpItemKindConstructor'] = lsp_kinds['constructor'] },
      { ['CmpItemKindField'] = lsp_kinds['field'] },
      { ['CmpItemKindProperty'] = lsp_kinds['property'] },
      { ['CmpItemKindUnit'] = lsp_kinds['unit'] },
      { ['CmpItemKindValue'] = lsp_kinds['value'] },
      { ['CmpItemKindEnum'] = lsp_kinds['enum'] },
      { ['CmpItemKindKeyword'] = lsp_kinds['keyword'] },
      { ['CmpItemKindReference'] = lsp_kinds['reference'] },
      { ['CmpItemKindConstant'] = lsp_kinds['constant'] },
      { ['CmpItemKindStruct'] = lsp_kinds['struct'] },
      { ['CmpItemKindEvent'] = lsp_kinds['event'] },
      { ['CmpItemKindOperator'] = lsp_kinds['operator'] },
      { ['CmpItemKindNamespace'] = lsp_kinds['namespace'] },
      { ['CmpItemKindPackage'] = lsp_kinds['package'] },
      { ['CmpItemKindString'] = lsp_kinds['string'] },
      { ['CmpItemKindNumber'] = lsp_kinds['number'] },
      { ['CmpItemKindBoolean'] = lsp_kinds['boolean'] },
      { ['CmpItemKindArray'] = lsp_kinds['array'] },
      { ['CmpItemKindObject'] = lsp_kinds['object'] },
      { ['CmpItemKindKey'] = lsp_kinds['key'] },
      { ['CmpItemKindNull'] = lsp_kinds['null'] },
      { ['CmpItemKindEnumMember'] = lsp_kinds['enumMember'] },
      { ['CmpItemKindClass'] = lsp_kinds['class'] },
      { ['CmpItemKindInterface'] = lsp_kinds['interface'] },
      { ['CmpItemKindTypeParameter'] = lsp_kinds['typeParameter'] },
    },
    navic = {
      { ['NavicIconsFile'] = { fg = theme.fg, bg = 'NONE' } },
      { ['NavicIconsModule'] = { fg = c.yelloworange, bg = 'NONE' } },
      { ['NavicIconsNamespace'] = { fg = theme.fg, bg = 'NONE' } },
      { ['NavicIconsPackage'] = { fg = theme.fg, bg = 'NONE' } },
      { ['NavicIconsClass'] = { fg = c.yellow, bg = 'NONE' } },
      { ['NavicIconsMethod'] = { fg = c.cyan, bg = 'NONE' } },
      { ['NavicIconsProperty'] = { fg = c.red, bg = 'NONE' } },
      { ['NavicIconsField'] = { fg = c.red, bg = 'NONE' } },
      { ['NavicIconsConstructor'] = { fg = c.yellow, bg = 'NONE' } },
      { ['NavicIconsEnum'] = { fg = c.orange, bg = 'NONE' } },
      { ['NavicIconsInterface'] = { fg = c.yellow, bg = 'NONE' } },
      { ['NavicIconsFunction'] = { fg = c.cyan, bg = 'NONE' } },
      { ['NavicIconsVariable'] = { fg = c.red, bg = 'NONE' } },
      { ['NavicIconsConstant'] = { fg = c.orange, bg = 'NONE' } },
      { ['NavicIconsString'] = { fg = c.yelloworange, bg = 'NONE' } },
      { ['NavicIconsNumber'] = { fg = c.orange, bg = 'NONE' } },
      { ['NavicIconsBoolean'] = { fg = c.orange, bg = 'NONE' } },
      { ['NavicIconsArray'] = { fg = c.yellow, bg = 'NONE' } },
      { ['NavicIconsObject'] = { fg = c.yellow, bg = 'NONE' } },
      { ['NavicIconsKey'] = { fg = c.purple, bg = 'NONE' } },
      { ['NavicIconsKeyword'] = { fg = c.purple, bg = 'NONE' } },
      { ['NavicIconsNull'] = { fg = c.orange, bg = 'NONE' } },
      { ['NavicIconsEnumMember'] = { fg = c.orange, bg = 'NONE' } },
      { ['NavicIconsStruct'] = { fg = c.cyan, bg = 'NONE' } },
      { ['NavicIconsEvent'] = { fg = c.yellow, bg = 'NONE' } },
      { ['NavicIconsOperator'] = { fg = theme.fg, bg = 'NONE' } },
      { ['NavicIconsTypeParameter'] = { fg = c.red, bg = 'NONE' } },
      { ['NavicText'] = { fg = theme.fg, bg = 'NONE' } },
      { ['NavicSeparator'] = { fg = theme.fg, bg = 'NONE' } },
    },
    packer = {
      { ['packerString'] = { fg = c.ui_orange, bg = 'NONE' } },
      { ['packerHash'] = { fg = c.ui4_blue, bg = 'NONE' } },
      { ['packerOutput'] = { fg = c.ui_purple, bg = 'NONE' } },
      { ['packerRelDate'] = { fg = c.gray, bg = 'NONE' } },
      { ['packerSuccess'] = { fg = c.success_green, bg = 'NONE' } },
      { ['packerStatusSuccess'] = { fg = c.ui4_blue, bg = 'NONE' } },
    },
    symbols_outline = {
      { ['SymbolsOutlineConnector'] = { fg = c.gray, bg = 'NONE' } },
      { ['FocusedSymbol'] = { fg = 'NONE', bg = '#36383F' } },
    },
    notify = {
      { ['NotifyERRORBorder'] = { fg = '#8A1F1F', bg = 'NONE' } },
      { ['NotifyWARNBorder'] = { fg = '#79491D', bg = 'NONE' } },
      { ['NotifyINFOBorder'] = { fg = c.ui_blue, bg = 'NONE' } },
      { ['NotifyDEBUGBorder'] = { fg = c.gray, bg = 'NONE' } },
      { ['NotifyTRACEBorder'] = { fg = '#4F3552', bg = 'NONE' } },
      { ['NotifyERRORIcon'] = { fg = c.error, bg = 'NONE' } },
      { ['NotifyWARNIcon'] = { fg = c.warn, bg = 'NONE' } },
      { ['NotifyINFOIcon'] = { fg = c.ui4_blue, bg = 'NONE' } },
      { ['NotifyDEBUGIcon'] = { fg = c.gray, bg = 'NONE' } },
      { ['NotifyTRACEIcon'] = { fg = c.ui_purple, bg = 'NONE' } },
      { ['NotifyERRORTitle'] = { fg = c.error, bg = 'NONE' } },
      { ['NotifyWARNTitle'] = { fg = c.warn, bg = 'NONE' } },
      { ['NotifyINFOTitle'] = { fg = c.ui4_blue, bg = 'NONE' } },
      { ['NotifyDEBUGTitle'] = { fg = c.gray, bg = 'NONE' } },
      { ['NotifyTRACETitle'] = { fg = c.ui_purple, bg = 'NONE' } },
    },
    hop = {
      { ['HopNextKey'] = { fg = '#4ae0ff', bg = 'NONE' } },
      { ['HopNextKey1'] = { fg = '#d44eed', bg = 'NONE' } },
      { ['HopNextKey2'] = { fg = '#b42ecd', bg = 'NONE' } },
      { ['HopUnmatched'] = { fg = c.gray, bg = 'NONE' } },
      { ['HopPreview'] = { fg = '#c7ba7d', bg = 'NONE' } },
    },
    crates = {
      { ['CratesNvimLoading'] = { fg = c.hint, bg = 'NONE' } },
      { ['CratesNvimVersion'] = { fg = c.hint, bg = 'NONE' } },
    },
  }
end

---Add in any enabled plugin's custom highlighting
---@param config horizon.Config
---@param plugins {[string]: horizon.Opts}
---@param highlights {[string]: horizon.Opts}
local function integrate_plugins(config, plugins, highlights)
  for plugin, enabled in pairs(config.plugins) do
    if enabled and plugins[plugin] then vim.list_extend(highlights, plugins[plugin]) end
  end
  return highlights
end

---@param config horizon.Config
function M.set_highlights(config)
  local bg = vim.o.background
  local highlights = integrate_plugins(config, get_plugin_highlights(bg), get_highlights(bg))
  for _, value in ipairs(highlights) do
    local name = next(value)
    api.nvim_set_hl(0, name, value[name])
  end
end

return M
