"This is taken from https://github.com/sjurgemeyer/vim-todo.txt-plugin
"somewhat amended by me
"currently more or less unused b/c I found that :sort/(\(\w\))/r does what I
"need for priority sorting

function! SortByPrio()
    " :sort/(\(\w\))/r"
    :sort/\([ax] \)\?(\w)/r
    "http://vim.wikia.com/wiki/Search_for_lines_not_containing_pattern_and_other_helpful_searches
    ":sort/^\(\(.*(\w).*\)\@!.\)*$/r
endfunction

function! SortByPrioPy()
:sort/\([ax] \)\?(\w)/r "orders (A) etc. appropriately, but puts comment text above tasks
python<<EOF
import vim, re
b = vim.current.buffer
nontask_lines = []
nontask_idx = []
for i, line in enumerate(b):
    m = re.match("([ax] )?\(\w\)", line)
    if m is None:
        nontask_idx.append(i)
        nontask_lines.append(line)
        #print line
for i in sorted(nontask_idx, reverse=True):
    del b[i]
#del b[nontask_idx]
for line in nontask_lines:
    b.append(line)
EOF
endfunction


function! SortByContext()
    :let sortString = '\@[^ $]+'
    :let matchString = '@[^ $]\+'
    :call TodoSort(sortString, matchString)
endfunction


function! TodoSort(sortString, matchString)
    :g/^$/d
    :execute "sort /\\v" . a:sortString . '/ r'
    :let start = search(a:matchString)
    :let end = search(a:matchString, 'b')
    :let lines = getline(start, end)
    :execute "normal " . start . "G"
    :execute 'normal "_d' . (end-start) . "j"
    :execute 'normal gg'
    :let lastSortField = ""
    :let firstline = 1
    for line in lines
        if line == ""
        else
            :let newSortField = matchstr(line,a:matchString)
            if lastSortField == newSortField || firstline == 1
            else
                :execute "normal I\<CR>"
            endif
            :let lastSortField = newSortField
            :let firstline = 0
            :execute "normal I" . line . "\<CR>"
        endif
    endfor
    :execute "normal I\<CR>"
endfunction
