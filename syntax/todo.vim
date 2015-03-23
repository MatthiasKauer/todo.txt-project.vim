" File: todo.txt.vim
" Description: Todo.txt syntax settings
" Author: Leandro Freitas <freitass@gmail.com>
" Licence: Vim licence
" Website: http://github.com/freitass/todo.txt.vim
" Version: 0.3

if exists("b:current_syntax")
    finish
endif

syntax match TodoDone '^[xX]\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityA '^([aA])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityB '^([bB])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityC '^([cC])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityD '^([dD])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityE '^([eE])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityF '^([fF])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityG '^([gG])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityH '^([hH])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityI '^([iI])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityJ '^([jJ])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityK '^([kK])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityL '^([lL])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityM '^([mM])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityN '^([nN])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityO '^([oO])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityP '^([pP])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityQ '^([qQ])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityR '^([rR])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityS '^([sS])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityT '^([tT])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityU '^([uU])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityV '^([vV])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityW '^([wW])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityX '^([xX])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityY '^([yY])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoPriorityZ '^([zZ])\s.\+$' contains=TodoDate,TodoProject,TodoContext
syntax match TodoDate '\d\{4\}-\d\{2\}-\d\{2\}' contains=NONE
syntax match TodoProject '+\w\+' contains=NONE
syntax match TodoContext '@\w\+' contains=NONE

" Other priority colours might be defined by the user
highlight default link TodoDone Comment
highlight default link TodoPriorityA Error
highlight default link TodoPriorityB Constant
highlight default link TodoPriorityC Identifier
highlight default link TodoPriorityD Statement
highlight default link TodoPriorityE Type
highlight default link TodoPriorityF Special


highlight default link TodoPriorityS Boolean
highlight default link TodoPriorityT Number
"dark brown on default bg
highlight default link TodoPriorityU Ignore
highlight default link TodoPriorityV Error
"Error is white on red
highlight default link TodoPriorityW Error
"todo is red on yellow bg
highlight default link TodoPriorityX Todo
"underlined is std green, but underlined
highlight default link TodoPriorityY Underlined
"type is cyan
highlight default link TodoPriorityZ Ignore
highlight default link TodoDate PreProc
highlight default link TodoProject Special
highlight default link TodoContext Special

let b:current_syntax = "todo"
