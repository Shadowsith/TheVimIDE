" searchtasks.vim - Search TODO, FIXME and XXX tasks
" Maintainer:   Gilson Filho <http://gilsondev.com>
" Version:      1.0

if exists("g:searchtasks_loaded") || &cp || v:version < 700
  finish
endif

let g:searchtasks_loaded=1

if !exists("g:searchtasks_list")
  let g:searchtasks_list=["TODO", "FIXME", "XXX"]
endif

" Search tasks {{{
function s:SearchTasks(directory)
  if a:directory
    echo "Directory is required (e.g: SearchTasks **/*.c)."
    return ''
  endif

  for task in g:searchtasks_list
    execute 'vimgrepadd /' . task . '/gj ' . a:directory
  endfor

  " show results
  cwindow
endfunction
" }}}


" Search tasks with :grep {{{
function s:SearchTasksGrep(directory)
  if a:directory
    echo "Directory is required (e.g: SearchTasksGrep **/*.c)."
    return ''
  endif

  for task in g:searchtasks_list
    execute 'silent :grepadd ' . task . ' ' . a:directory
  endfor

  " show results
  cwindow
endfunction
" }}}

if exists("grepadd") || v:version > 700
  command -nargs=1 SearchTasksGrep call s:SearchTasksGrep('<args>')
endif
command -nargs=1 SearchTasks call s:SearchTasks('<args>')
" vim:set sw=2 sts=2:
