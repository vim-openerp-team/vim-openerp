" Vim plugin for highlighting current line.
" Maintainer: Ansuman Mohanty <ansumanm@gmail.com>
" Last Change: 2006 Sept 12
" Inspired from matchparen pluggin
" Exit quickly when:
" - this plugin was already loaded (or disabled)
" - when 'compatible' is set
" - the "CursorMoved" autocmd event is not availble.

hi CurrentLine    term=bold cterm=bold gui=bold guibg=#B50DB9

if exists("g:loaded_highlightCurLine") || &cp || !exists("##CursorMoved")
  finish
endif
let g:loaded_highlightCurLine = 1

augroup highlightCurLine
  " Replace all matchparen autocommands
  autocmd! CursorMoved,CursorMovedI * call s:Highlight_Current_Line()
augroup END

" Skip the rest if it was already done.
if exists("*s:Highlight_Current_Line")
  finish
endif

let cpo_save = &cpo
set cpo-=C

" The function that is invoked (very often) to define a ":match" highlighting
" for any matching paren.
function! s:Highlight_Current_Line()
  " Remove any previous match.
  if exists('w:curline_hl_on') && w:curline_hl_on
    2match none
    let w:curline_hl_on = 0
  endif

  " Avoid that we remove the popup menu.
  if pumvisible()
    return
  endif

    exe '2match CurrentLine /.*\%#.*/'
    let w:curline_hl_on = 1
endfunction

" Define commands that will disable and enable the plugin.
command! NoHighCurLine 2match none | unlet! g:loaded_highlightCurLine | au! highlightCurLine
command! DoHighCurLine runtime plugin/matchparen.vim | doau CursorMoved

let &cpo = cpo_save
