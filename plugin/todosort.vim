"This is taken from https://github.com/sjurgemeyer/vim-todo.txt-plugin
"somewhat amended by me
"currently more or less unused b/c I found that :sort/(\(\w\))/r does what I
"need for priority sorting

function! SortByPrio()
    :sort/(\(\w\))/r"
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
