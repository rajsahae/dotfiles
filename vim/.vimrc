" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2006 Nov 16
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
  set backupdir=~/.vimswaps
  set directory=~/.vimswaps " keep swapfiles in the backup directory
endif

set history=1000	" keep 1000 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set showmode            " Show current mode at the bottom
set gcr=a:blinkon0      " Disable cursor blink
set incsearch		" do incremental searching
set visualbell          " No sounds
set autoread            " Autoload files changed outside of Vim

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
	set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set cindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 	\ | wincmd p | diffthis

" Added by Raj Sahae 2011.09.19
set softtabstop=2	" set tabs to be 2 spaces instead of 8
set shiftwidth=2	" set shiftwidth to be 2 instead of 8
set expandtab		" use spaces to insert a tab
set sm				" search magic on
set guifont=monospace\ 13	" Use monospaced font
set number
set ignorecase		" ignore case in a pattern
set smartcase		" Ignore case when pattern is lowercase letters only
"set vb				" Use visual bell instead of beeping
set autoindent		" always set autoindenting on

" Java Highlighting, Syntax, and C++ error marking
"let java_highlight_all=1
"let java_highlight_functions="style"
"let java_highlight_cpp_keywords=1

" Added by Raj Sahae 2011.12.13
"command Rake !rake
"command WR w|!rake

" Added by Raj Sahae 2012.01.03
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
"compiler ruby         " Enable compiler support for ruby

" Added by Raj Sahae 2012.01.11
"runtime bundles/tplugin_vim/macros/tplugin.vim
"runtime bundles/tskeleton/macros/tskeleton.vim

" Added by Raj Sahae 2012.01.23
set nospell             " Enable spellchecker

" Added by Raj Sahae 2012.02.15
set foldmethod=indent   " Set foldmethod to fold by indents

" Added by Raj Sahae 2012.06.10
let mapleader = ","     " Set leader to comma
colorscheme desert256
" Swap the  ' and ` keys
nnoremap ' `
nnoremap ` '
" Single character insert
nmap <Leader><Space> i_<Esc>r
runtime macros/matchit.vim    " Enable extended % matching
set wildmenu                  " use the wildmenu for tab completion
set wildmode=list:longest     " shell style completion
set title                     " Set terminal title
set scrolloff=3               " Maintain 3 lines of context around the cursor
" Catch trailing whitespace
set listchars=tab:>-,trail:.,eol:$
nmap <silent> <leader>s :set nolist!<CR>
set shortmess=atI             " Stifle interrupting prompts
nnoremap <leader>c <C-w>c
nnoremap <leader>s <C-w>s<C-w>j
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>w <C-w>w
nnoremap <leader><leader>w :w<CR>
" key mappings for pair completion
inoremap ( ()<Left>
inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap <expr> }  strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"
