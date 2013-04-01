" :Less
" turn vim into a pager for psql aligned results 
fun! Less()
  set nocompatible
  set nowrap
  set scrollopt=hor
  set scrollbind
  set number
  execute 'above split'
  " resize upper window to one line; two lines are not needed because vim adds separating line
  execute 'resize 1'
  " switch to lower window and scroll 2 lines down 
  wincmd j
  execute 'norm! 2^E'
  " hide statusline in lower window
  set laststatus=0
  " hide contents of upper statusline. editor note: do not remove trailing spaces in next line!
  set statusline=\  
  " arrows do scrolling instead of moving
  nmap ^[OC zL
  nmap ^[OB ^E
  nmap ^[OD zH
  nmap ^[OA ^Y
  nmap <Space> <PageDown>
  " faster quit (I tend to forget about the upper panel)
  nmap q :qa^M
  nmap Q :qa^M
endfun
command! -nargs=0 Less call Less()


