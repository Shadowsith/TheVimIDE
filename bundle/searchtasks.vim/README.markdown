# Search Tasks - Search TODO, FIXME and XXX in your project


## Introduction

When you develop, it is likely that inserts comments that serves
as a reminder of what needs to improve, implement, or withdraw future.
You also have situations where you need to put a comment from a hack 
who made or an encoding that need a better fix.

For it is common to use labels TODO, FIXME and XXX in comments. 
But how does all of them to look in a directory containing your source code?

This plugin help and do a scan of all kinds of comments that matches the labels used.


## Commands

```vimL
" Search in root directory (TODO, FIXME, XXX)
:SearchTasks .

" Search in directory app/ in files .py
:SearchTasks app/*.py

" Search with grep
:SearchTasksGrep **/*.php
```

## Configuration

If you want to change or enter new labels for searchtask search, just enter the following in your configuration ``.vimrc``:

```vimL
" List occurrences for search
let g:searchtasks_list=["TODO", "FIXME", "XXX"]
```
