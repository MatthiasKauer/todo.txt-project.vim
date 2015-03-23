function! DateDelta(delta)
python << EOF
import vim
from datetime import date, timedelta
py_delta = int(vim.eval("a:delta"))
#print py_delta

yesterday = date.today()+timedelta(py_delta);
date_str = yesterday.strftime('%Y-%m-%d')
#print date_str
#print yesterday.strftime('%Y-%m-%d')
#vim.command("let g:ytd=" + yesterday.strftime('%Y-%m-%d'))
vim.command("return '"+ date_str + "'")
EOF
endfunction

fun! GetCurrentFileName()
python << EOF
import vim
fname= vim.current.buffer.name
vim.command("return ". fname)
EOF
endfun

fun! AddOneToDateMultiple(movement, in_fnames)
python<<EOF
fnames = vim.eval("a:in_fnames")
pymov=int(vim.eval("a:movement"))

out_list =[]
for fname in fnames:
    out_list.append(vim.eval("AddOneToDate("+str(pymov)+",'"+fname +"')"))

vim.command("return " + str(out_list))
EOF
endfun

fun! AddOneToDate(movement, in_fname)
python<<EOF
from datetime import datetime, timedelta
import re

py_fname=vim.eval("a:in_fname")
if not py_fname:
    vim.command("return 'no_date'")
    print "AddOneToDate: no date could be found"
else:
    pymov=int(vim.eval("a:movement"))
#r= re.compile(r'\d{4}-\d{2}-\d{2}', pydate)
    regex =r'\d{4}-\d{2}-\d{2}'
    match = re.search(regex, py_fname)
    if match:
        date = datetime.strptime(match.group(0),'%Y-%m-%d').date()
        date_new = date +timedelta(pymov);
        #out_fname = py_fname[:match.start()] + date_new.strftime('%Y-%m-%d')
        out_fname = re.sub(regex, date_new.strftime('%Y-%m-%d'), py_fname)
        #print out_fname
        
        vim.command("return '"+ out_fname + "'")
    else:
        vim.command("return 'no_date'")
        print "AddOneToDate: no date could be found"
EOF
endfun

fun! TodoGoBack()
    let l:fname=expand('%:t')
    let l:path=expand('%:p:h')
    let l:fnamenew = AddOneToDate("-1", l:fname)
    " echo l:fnamenew
    silent exe ":e " . l:fnamenew
endfun

fun! TodoGoForward()
    let l:fname=expand('%:t')
    let l:path=expand('%:p:h')
    let l:fnamenew = AddOneToDate("1", l:fname)
    " echo l:fnamenew
    silent exe ":e " . l:fnamenew
endfun

fun! GetCurrentWindowFiles()
python <<EOF
out_list = []
for w in vim.windows:
    b = w.buffer
    out_list.append(b.name)
vim.command("return " + str(out_list))
EOF
endfun

fun! TodoTogglePrepend(prependchar)
python << endpython
py_prepend= vim.eval('a:prependchar') + ' '
l = vim.current.line
if l[:2]==py_prepend:
    vim.current.line = l[2:]
else:
    vim.current.line =py_prepend + l
endpython
endfun

fun! InsertNewLine(insert_string)
python << pythonend
l = vim.current.line
w = vim.current.window
b = vim.current.buffer
row = w.cursor[0]
py_str = vim.eval("a:insert_string")
#py_str += " ."
if len(l) > 0:
    b.append(py_str, row)    
    row = row+1
else:
    vim.current.line = py_str

w.cursor = (row, len(py_str))
#startinsert! = append
vim.command("startinsert!")
pythonend
endfun

fun! GetNextGlobFile(movement,path, fname)
python << EOF
import glob,re, os
py_fname = vim.eval("a:fname")
py_mov = int(vim.eval("a:movement"))
#py_path = re.sub(r"(\\)+", "/", vim.eval("a:path"))
#print("pypath = %s" % (py_path) )
py_path = os.path.expanduser(os.path.normpath(vim.eval("a:path")))
#print("pypath = %s" % (py_path) )
#print("py_fname = %s" % (py_fname))

filext = py_fname.split('.')[-1]
files = sorted(glob.glob(py_path + "/*."+filext))
cleanfiles = []
for f in files:
    #cleanfiles.append(re.sub(r"(\\)+", "/", f))
    cleanfiles.append(os.path.normpath(f))

#print("GetNextGlobFile: Found files")
#print cleanfiles
#print files

full_file = os.path.normpath(py_path + "/" + py_fname)
pos = (cleanfiles.index(full_file) + py_mov ) % len(files) if full_file in cleanfiles else None
if pos is not None:
    vim.command("return '" + str( cleanfiles[pos] )+ "'" )
else:
    #can only print one line, otherwise vim will stop and wait for an extra click! this works:
    print("GetNextGlobFile: could not find, returning last instead")
    #this is too long
    #print("GetNextGlobFile: could not find %s, returning last = %s instead" % (py_fname, str(cleanfiles[-1])) )
    #this, I don't remember (2014-05)
    #print("search string: " + str(full_file))
    #print(" - returning last file instead: "+ str(cleanfiles[-1]) + "'")
    vim.command("return '" + str( cleanfiles[-1]) + "'" )
EOF
endfun

fun! ProjMove(movement)
    let l:fname=expand('%:t')
    let l:path=expand('%:p:h')
    let l:fnamenew = GetNextGlobFile(a:movement,l:path, l:fname)

    silent exe ":write"
    silent exe ":e " . l:fnamenew
endfunc

fun! TodoMoveAll(movement)
    " http://stackoverflow.com/questions/4198503/number-of-windows-in-vim
    let l:wincnt = winnr('$')
    let l:fnames=GetCurrentWindowFiles()
    let l:fnamesnew=AddOneToDateMultiple(a:movement, l:fnames)
    silent exe ":wall"
    silent exe ":only"
python<<EOF
import re
is_first=True
pfnamesnew = vim.eval("l:fnamesnew")

for fname in sorted(pfnamesnew):
    cleanfname = re.sub(r"(\\)+", "/", fname)
    if is_first:
        is_first=False
        vim.command(":e " + cleanfname)
    else:
        vim.command(":sp " + cleanfname)
EOF
endfun

"Create .todo file for x days in the future (from current file)
"this may already be fulfilled by TodoGoForward()
fun! CreateTodo(amount)
let l:fname=expand('%:t')
python << EOF
py_amount = int(vim.eval("a:amount"))

EOF
endfun

" http://vim.wikia.com/wiki/Opening_multiple_files_from_a_single_command-line
fun! SplitMultiple(...)
  if(a:0 == 0)
    sp
  else
    let i = a:0
    while(i > 0)
      execute 'let file = a:' . i
      execute 'sp ' . file
      let i = i - 1
    endwhile
  endif
endfun

"go to todo folder
fun! GotoTodo()
    "let the_path="~/SparkleShare/mytodolist"
    let l:the_path="~/Seafile/mytodolist"
    silent exe ":wall"
    silent exe ":cd " . l:the_path
    silent exe ":only"
    echo "went to " . l:the_path
endfun

fun! OpenShopping(filext)
    let l:path=g:mini_todo_dir . "/shopping"
    silent exe ":cd " . l:path

    let l:projname=GetNextGlobFile("-1", l:path, "cannot_find_training" . a:filext)
    exe ":e " . l:projname
endfun

fun! OpenTraining(filext)
    " echo "executing OpenTraining"
    " call GotoTodo()
    " silent exe ":cd training"
    " let l:path=expand('%:p:h')
    let l:path=g:mini_todo_dir . "/training"
    silent exe ":cd " . l:path
    " echo "OpenTraining; l:path=" . l:path
    
    let l:projname=GetNextGlobFile("-1", l:path, "cannot_find_training" . a:filext)
    " echo "projname" . l:projname
    exe ":e + " . l:projname
    "found out that + also moves to last line

    "go to last line
    " silent exe ":normal G"
    " silent exe ":only"
endfun

fun! OpenBooks()
    "call GotoTodo()
    let l:path=g:mini_todo_dir . "/books"
    " silent exe ":cd books"
    " let l:path=expand('%:p:h')
    " echo l:path
    
    let l:projname=GetNextGlobFile("-1", l:path, "cannot_find_books.tcl")
    silent exe ":e " . l:projname
    silent exe ":only"
endfun

"open todo file
fun! OpenTodo()
    " let the_path="~/SparkleShare/mytodolist"
    " let the_path="~/Seafile/mytodolist"
    silent exe ":wall"
    silent exe ":cd " . g:mini_todo_dir
    silent exe ":only"

    let todayname=strftime("%Y-%m-%d"). ".tcl"
    " silent exe ":e " .the_path . "/" . todayname

    " let l:path=expand('%:p:h')
    let l:fnamenew = GetNextGlobFile("-1",g:mini_todo_dir, todayname)

    "echo l:fnamenew
    silent exe ":e " . l:fnamenew
    " silent exe ":sp " . the_path . "/" . todayname
    silent exe ":sp " . todayname
endfun

fun! OpenProjectPlan()
    " let the_path="~/SparkleShare/mytodolist"
    let the_path="~/Seafile/mytodolist"
    silent exe ":wall"
    silent exe ":cd " . the_path
    silent exe ":only"

    let todayname=strftime("%Y-%m-%d"). ".tcl"

    silent exe ":e " . the_path . "/" . todayname
    let l:path=expand('%:p:h')
    let proj_path = l:path . "/active_proj"

    let projname=GetNextGlobFile("-1", proj_path, "cannot_be_found.tcl")

    " echo "ytd: " . ytdname . ", today: ". todayname
    silent exe ":e " . projname
    silent exe ":sp " . the_path . "/" . todayname
    silent exe ":wincmd b"
endfun


" au BufRead,BufNewFile *.todo   set filetype=todo
au BufRead,BufNewFile *.tcl   set filetype=todo
au BufRead,BufNewFile *.tcl.cpt   set filetype=todo
au BufRead,BufNewFile todo.txt   set filetype=todo
" nnoremap <leader>tn :call TodoGoForward()<CR>
" nnoremap <leader>tp :call TodoGoBack()<CR>

"no idea what this is supposed to do
fun! PrintBuffer()
python <<EOF
import vim
b = vim.current.buffer
r = vim.current.range
tosearch= "".join(b[r.start:])
args = re.search(r'\(.*?\)', tosearch, flags=re.DOTALL)
if args:
    return args.group(0)
else:
    return None
EOF
endfun

"changes the priority of a certain task one up or down or makes it a task with
"a priority.
fun! PrioChange(direction)
python << EOF
import re
import string

pydir = int( vim.eval("a:direction") )
l = vim.current.line
done_str = re.search(r"^x ", l)
if done_str: #if task is already done, don't change prio anymore
    print("this task is already done - not changing prio!")
else:
    prio_str = re.search(r"^\(\w\)\s", l)

#allTheLetters = string.uppercase
    allTheLetters = "ABCDEFZ"
    if prio_str:
        prio = allTheLetters.index(prio_str.group(0)[1])
        vim.current.line = "(" + allTheLetters[(prio+pydir)%len(allTheLetters)] + ") " + l[4:]
    else:
        if pydir >0 :
            vim.current.line = "(" + allTheLetters[0] +  ") " + l     
        elif pydir <0:
            vim.current.line = "(" + allTheLetters[-1] +  ") " + l     
        
EOF
endfun

