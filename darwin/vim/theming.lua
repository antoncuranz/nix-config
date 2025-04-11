-- GLOBALS
cmd = vim.cmd     -- execute Vim commands
exec = vim.api.nvim_exec 	-- execute Vimscript
fn = vim.fn       -- call Vim functions
g = vim.g         -- global variables
opt = vim.opt     -- global/buffer/windows-scoped options

function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function CalendarToggle()
  local buf_nr = vim.fn.bufnr("__Calendar")
  if buf_nr > 0 then
    vim.api.nvim_buf_delete(buf_nr, {force=true})
  else
    vim.cmd(":Telekasten show_calendar")
  end
end

-- MAPPINGS
map("v", "<C-c>", '"*y')
map("n", "<C-t>", ":lua CalendarToggle()<cr>")

-- THEMING
opt.termguicolors = true
function changeColorscheme()
  macOS_darkmode = fn.systemlist("defaults read -g AppleInterfaceStyle")[1] == "Dark"
  if macOS_darkmode then
    cmd("colorscheme xcodedarkhc")
  else
    cmd("colorscheme xcodelight")
  end
end
changeColorscheme()


cmd [[
  autocmd Signal * lua changeColorscheme()

  hi! Normal guibg=none
  hi! link LspReferenceText CursorColumn
  hi! link LspReferenceRead CursorColumn
  hi! link LspReferenceWrite CursorColumn
]]

-- STATUSLINE
cmd [[
  set statusline=%#Special#%{(mode()=='n')?'\ \ NORMAL\ ':''}
  set statusline+=%#Number#%{(mode()=='i')?'\ \ INSERT\ ':''}
  set statusline+=%#DiffDelete#%{(mode()=='r')?'\ \ RPLACE\ ':''}
  set statusline+=%#PreProc#%{(mode()=='v')?'\ \ VISUAL\ ':''}
  set statusline+=%#Operator#      " colour
  set statusline+=\ %n\            " buffer number
  set statusline+=%R               " readonly flag
  set statusline+=%M               " modified [+] flag
  set statusline+=\ %t\            " short file name
  set statusline+=%=               " right align
  set statusline+=\ %Y\            " file type
  set statusline+=\ %3l:%-2c\      " line + column
  set statusline+=%#Special#       " colour
  set statusline+=\ %3p%%\         " percentage
]]
