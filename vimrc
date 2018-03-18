" Modeline and Notes {
" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
" }

" Environment {
  " Identify platform {
    silent function! OSX()
      return has('macunix')
    endfunction
    silent function! LINUX()
      return has('unix') && !has('macunix') && !has('win32unix')
    endfunction
    silent function! WINDOWS()
      return  (has('win32') || has('win64'))
    endfunction
  " }

  " Basics {
    set nocompatible        " Must be first line
    if !WINDOWS()
      set shell=/bin/sh
    endif
  " }

  " Windows Compatible {
    " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
    " across (heterogeneous) systems easier.
    if WINDOWS()
      set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    endif
  " }

  " Arrow Key Fix {
     " https://github.com/spf13/spf13-vim/issues/780
     if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
       inoremap <silent> <C-[>OC <RIGHT>
     endif
  " }

" }

" Use before config if available {
  if filereadable(expand("~/.vimrc.before"))
    source ~/.vimrc.before
  endif
" }

" Use bundles config {
  if filereadable(expand("~/.vimrc.plugins"))
    source ~/.vimrc.plugins
  endif
" }

" Plug Plugins {
  " Specify a directory for plugins
  " - For Neovim: ~/.local/share/nvim/plugged
  " - Avoid using standard Vim directory names like 'plugin'
  call plug#begin('~/.vim/plugged')

  " Make sure you use single quotes

  " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
  "Plug 'junegunn/vim-easy-align'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'vim-syntastic/syntastic'
  Plug 'spf13/vim-autoclose'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-fugitive'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'luochen1990/rainbow'
  Plug 'flazz/vim-colorschemes'
  Plug 'vim-scripts/sessionman.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'terryma/vim-multiple-cursors'

  " Build YouCompleteMe {
    function! BuildYCM(info)
      " info is a dictionary with 3 fields
      " - name:   name of the plugin
      " - status: 'installed', 'updated', or 'unchanged'
      " - force:  set on PlugInstall! or PlugUpdate!
      if a:info.status == 'updated' || a:info.force
        !git submodule update --init --force --recursive
        echom "./install.py " . g:spf13_ycm_completer
        exec "./install.py " . g:spf13_ycm_completer
      endif
    endfunction
  " }
  Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }

  " Any valid git URL is allowed
  "Plug 'https://github.com/junegunn/vim-github-dashboard.git'

  " Multiple Plug commands can be written in a single line using | separators
  "Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

  " On-demand loading
  Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on':  ['NERDTreeToggle', 'NERDTreeFind'] }
  Plug 'scrooloose/nerdcommenter', { 'on': 'NERDComToggleComment' }
  Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
  Plug 'jpalardy/vim-slime', { 'on': ['<Plug>SlimeRegionSend',
                              \       '<Plug>SlimeParagraphSend',
                              \       '<Plug>SlimeLineSend',
                              \       '<Plug>SlimeMotionSend',
                              \       '<Plug>SlimeConfig',
                              \       'SlimeSend'] }
  Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
  Plug 'brookhong/cscope.vim', { 'for': ['c', 'cpp'] }
  Plug 'python-mode/python-mode', { 'for': 'python' }
  Plug 'spf13/PIV', { 'for': 'php' }
  " Using manual indentation to express dependency
  Plug 'kien/ctrlp.vim', {
        \ 'on': ['CtrlP', 'CtrlPMRU', 'CtrlPBuffer', 'CtrlPMixed'] }
    Plug 'tacahiroy/ctrlp-funky', { 'on': 'CtrlPFunky' }
  "Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

  " Using a non-master branch
  Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

  " Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
  Plug 'fatih/vim-go', { 'tag': '*' }

  " Plugin options
  "Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

  " Plugin outside ~/.vim/plugged with post-update hook
  "Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

  " Unmanaged plugin (manually installed and updated)
  "Plug '~/my-prototype-plugin'

  " Initialize plugin system
  call plug#end()

" }

" General {
  set background=dark         " Assume a dark background

  " Allow to trigger background
  function! ToggleBG()
    let s:tbg = &background
    " Inversion
    if s:tbg == "dark"
      set background=light
    else
      set background=dark
    endif
  endfunction
  noremap <leader>bg :call ToggleBG()<CR>

  " if !has('gui')
      "set term=$TERM          " Make arrow and other keys work
  " endif
  filetype plugin indent on   " Automatically detect file types.
  syntax on                   " Syntax highlighting
  set mouse=a                 " Automatically enable mouse usage
  set mousehide               " Hide the mouse cursor while typing
  scriptencoding utf-8

  if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
      set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
      set clipboard=unnamed
    endif
  endif

  " Most prefer to automatically switch to the current file directory when
  " a new buffer is opened; to prevent this behavior, add the following to
  " your .vimrc.before.local file:
  "   let g:spf13_no_autochdir = 1
  if !exists('g:spf13_no_autochdir')
    autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
    " Always switch to the current file directory
  endif

  "set autowrite                       " Automatically write a file when leaving a modified buffer
  set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
  set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
  set virtualedit=onemore             " Allow for cursor beyond last character
  set history=1000                    " Store a ton of history (default is 20)
  set spell                           " Spell checking on
  set hidden                          " Allow buffer switching without saving
  set iskeyword-=.                    " '.' is an end of word designator
  set iskeyword-=#                    " '#' is an end of word designator
  set iskeyword-=-                    " '-' is an end of word designator

  " Instead of reverting the cursor to the last position in the buffer, we
  " set it to the first line when editing a git commit message
  au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

  " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
  " Restore cursor to file position in previous editing session
  " To disable this, add the following to your .vimrc.before.local file:
  "   let g:spf13_no_restore_cursor = 1
  if !exists('g:spf13_no_restore_cursor')
    function! ResCur()
      if line("'\"") <= line("$")
        silent! normal! g`"
        return 1
      endif
    endfunction
    augroup resCur
      autocmd!
      autocmd BufWinEnter * call ResCur()
    augroup END
  endif

  " Setting up the directories {
    set backup                  " Backups are nice ...
    if has('persistent_undo')
      set undofile                " So is persistent undo ...
      set undolevels=1000         " Maximum number of changes that can be undone
      set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
    endif

    " To disable views add the following to your .vimrc.before.local file:
    "   let g:spf13_no_views = 1
    if !exists('g:spf13_no_views')
      " Add exclusions to mkview and loadview
      " eg: *.*, svn-commit.tmp
      let g:skipview_files = [
          \ '\[example pattern\]'
          \ ]
    endif
  " }

" }

" Vim UI {
  if !exists('g:override_spf13_bundles') && filereadable(expand("~/.vim/plugged/vim-colorschemes/colors/solarized.vim"))
    let g:solarized_termcolors=256
    let g:solarized_termtrans=1
    let g:solarized_contrast="normal"
    let g:solarized_visibility="normal"
    color solarized             " Load a colorscheme
  endif

  set tabpagemax=15               " Only show 15 tabs
  set showmode                    " Display the current mode

  set cursorline                  " Highlight current line

  highlight clear SignColumn      " SignColumn should match background
  highlight clear LineNr          " Current line number row will have same background color in relative mode
  "highlight clear CursorLineNr    " Remove highlight color from current line number

  if has('cmdline_info')
      set ruler                   " Show the ruler
      set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
      set showcmd                 " Show partial commands in status line and
                                  " Selected characters/lines in visual mode
  endif

  if has('statusline')
    set laststatus=2
    " Broken down into easily includeable segments
    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    if !exists('g:override_spf13_bundles')
      set statusline+=%{fugitive#statusline()} " Git Hotness
    endif
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
  endif

  set backspace=indent,eol,start  " Backspace for dummies
  set linespace=0                 " No extra spaces between rows
  set number                      " Line numbers on
  set showmatch                   " Show matching brackets/parenthesis
  set incsearch                   " Find as you type search
  set hlsearch                    " Highlight search terms
  set winminheight=0              " Windows can be 0 line high
  set ignorecase                  " Case insensitive search
  set smartcase                   " Case sensitive when uc present
  set wildmenu                    " Show list instead of just completing
  set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
  set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
  set scrolljump=5                " Lines to scroll when cursor leaves screen
  set scrolloff=3                 " Minimum lines to keep above and below cursor
  set foldenable                  " Auto fold code
  set list
  set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" }

" Formatting {
  set nowrap                      " Do not wrap long lines
  set autoindent                  " Indent at the same level of the previous line
  set shiftwidth=2                " Use indents of 4 spaces
  set expandtab                   " Tabs are spaces, not tabs
  set tabstop=2                   " An indentation every four columns
  set softtabstop=2               " Let backspace delete indent
  set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
  set splitright                  " Puts new vsplit windows to the right of the current
  set splitbelow                  " Puts new split windows to the bottom of the current
  "set matchpairs+=<:>             " Match, to be used with %
  set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
  "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
  " Remove trailing whitespaces and ^M chars
  " To disable the stripping of whitespace, add the following to your
  " .vimrc.before.local file:
  "   let g:spf13_keep_trailing_whitespace = 1
  autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> if !exists('g:spf13_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
  "autocmd FileType go autocmd BufWritePre <buffer> Fmt
  autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
  autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
  " preceding line best in a plugin but here for now.

  autocmd BufNewFile,BufRead *.coffee set filetype=coffee

  " Workaround vim-commentary for Haskell
  autocmd FileType haskell setlocal commentstring=--\ %s
  " Workaround broken colour highlighting in Haskell
  autocmd FileType haskell,rust setlocal nospell

" }

" Key (re)Mappings {
  " The default leader is '\', but many people prefer ',' as it's in a standard
  " location. To override this behavior and set it back to '\' (or any other
  " character) add the following to your .vimrc.before.local file:
  "   let g:spf13_leader='\'
  if !exists('g:spf13_leader')
    let mapleader = ','
  else
    let mapleader=g:spf13_leader
  endif
  if !exists('g:spf13_localleader')
    let maplocalleader = '_'
  else
    let maplocalleader=g:spf13_localleader
  endif

  " The default mappings for editing and applying the spf13 configuration
  " are <leader>ev and <leader>sv respectively. Change them to your preference
  " by adding the following to your .vimrc.before.local file:
  "   let g:spf13_edit_config_mapping='<leader>ec'
  "   let g:spf13_apply_config_mapping='<leader>sc'
  if !exists('g:spf13_edit_config_mapping')
    let s:spf13_edit_config_mapping = '<leader>ev'
  else
    let s:spf13_edit_config_mapping = g:spf13_edit_config_mapping
  endif
  if !exists('g:spf13_apply_config_mapping')
    let s:spf13_apply_config_mapping = '<leader>sv'
  else
    let s:spf13_apply_config_mapping = g:spf13_apply_config_mapping
  endif

  " Easier moving in tabs and windows
  " The lines conflict with the default digraph mapping of <C-K>
  " If you prefer that functionality, add the following to your
  " .vimrc.before.local file:
  "   let g:spf13_no_easyWindows = 1
  if !exists('g:spf13_no_easyWindows')
    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_
  endif

  " Wrapped lines goes down/up to next row, rather than next line in file.
  noremap j gj
  noremap k gk

  " End/Start of line motion keys act relative to row/wrap width in the
  " presence of `:set wrap`, and relative to line for `:set nowrap`.
  " Default vim behaviour is to act relative to text line in both cases
  " If you prefer the default behaviour, add the following to your
  " .vimrc.before.local file:
  "   let g:spf13_no_wrapRelMotion = 1
  if !exists('g:spf13_no_wrapRelMotion')
    " Same for 0, home, end, etc
    function! WrapRelativeMotion(key, ...)
      let vis_sel=""
      if a:0
        let vis_sel="gv"
      endif
      if &wrap
        execute "normal!" vis_sel . "g" . a:key
      else
        execute "normal!" vis_sel . a:key
      endif
    endfunction

    " Map g* keys in Normal, Operator-pending, and Visual+select
    noremap $ :call WrapRelativeMotion("$")<CR>
    noremap <End> :call WrapRelativeMotion("$")<CR>
    noremap 0 :call WrapRelativeMotion("0")<CR>
    noremap <Home> :call WrapRelativeMotion("0")<CR>
    noremap ^ :call WrapRelativeMotion("^")<CR>
    " Overwrite the operator pending $/<End> mappings from above
    " to force inclusive motion with :execute normal!
    onoremap $ v:call WrapRelativeMotion("$")<CR>
    onoremap <End> v:call WrapRelativeMotion("$")<CR>
    " Overwrite the Visual+select mode mappings from above
    " to ensure the correct vis_sel flag is passed to function
    vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
  endif

  " The following two lines conflict with moving to top and
  " bottom of the screen
  " If you prefer that functionality, add the following to your
  " .vimrc.before.local file:
  "   let g:spf13_no_fastTabs = 1
  if !exists('g:spf13_no_fastTabs')
    map <S-H> gT
    map <S-L> gt
  endif

  " Stupid shift key fixes
  if !exists('g:spf13_no_keyfixes')
    if has("user_commands")
      command! -bang -nargs=* -complete=file E e<bang> <args>
      command! -bang -nargs=* -complete=file W w<bang> <args>
      command! -bang -nargs=* -complete=file Wq wq<bang> <args>
      command! -bang -nargs=* -complete=file WQ wq<bang> <args>
      command! -bang Wa wa<bang>
      command! -bang WA wa<bang>
      command! -bang Q q<bang>
      command! -bang QA qa<bang>
      command! -bang Qa qa<bang>
    endif
    cmap Tabe tabe
  endif

  " Yank from the cursor to the end of the line, to be consistent with C and D.
  nnoremap Y y$

  " Code folding options
  nmap <leader>f0 :set foldlevel=0<CR>
  nmap <leader>f1 :set foldlevel=1<CR>
  nmap <leader>f2 :set foldlevel=2<CR>
  nmap <leader>f3 :set foldlevel=3<CR>
  nmap <leader>f4 :set foldlevel=4<CR>
  nmap <leader>f5 :set foldlevel=5<CR>
  nmap <leader>f6 :set foldlevel=6<CR>
  nmap <leader>f7 :set foldlevel=7<CR>
  nmap <leader>f8 :set foldlevel=8<CR>
  nmap <leader>f9 :set foldlevel=9<CR>

  " Most prefer to toggle search highlighting rather than clear the current
  " search results. To clear search highlighting rather than toggle it on
  " and off, add the following to your .vimrc.before.local file:
  "   let g:spf13_clear_search_highlight = 1
  if exists('g:spf13_clear_search_highlight')
    nmap <silent> <leader>/ :nohlsearch<CR>
  else
    nmap <silent> <leader>/ :set invhlsearch<CR>
  endif


  " Find merge conflict markers
  map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

  " Shortcuts
  " Change Working Directory to that of the current file
  cmap cwd lcd %:p:h
  cmap cd. lcd %:p:h

  " Visual shifting (does not exit Visual mode)
  vnoremap < <gv
  vnoremap > >gv

  " Allow using the repeat operator with a visual selection (!)
  " http://stackoverflow.com/a/8064607/127816
  vnoremap . :normal .<CR>

  " For when you forget to sudo.. Really Write the file.
  cmap w!! w !sudo tee % >/dev/null

  " Some helpers to edit mode
  " http://vimcasts.org/e/14
  cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
  map <leader>ew :e %%
  map <leader>es :sp %%
  map <leader>ev :vsp %%
  map <leader>et :tabe %%

  " Adjust viewports to the same size
  map <Leader>= <C-w>=

  " Map <Leader>ff to display all lines with keyword under cursor
  " and ask which one to jump to
  nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

  " Easier horizontal scrolling
  map zl zL
  map zh zH

  " Easier formatting
  nnoremap <silent> <leader>q gwip

  " FIXME: Revert this f70be548
  " fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
  map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

" }

" Plugins Configuration {
  " airline {
    " smarter tab line
    let g:airline#extensions#tabline#enabled = 1
    " tabline separators
    "let g:airline#extensions#tabline#left_sep = ' '
    "let g:airline#extensions#tabline#left_alt_sep = '|'
    " tabline file path [default, jsformatter, unique_tail, unique_tail_improved]
    let g:airline#extensions#tabline#formatter = 'unique_tail'
    " powerline fonts
    let g:airline_powerline_fonts = 1

    " Set configuration options for the statusline plugin vim-airline.
    " Use the powerline theme and optionally enable powerline symbols.
    " To use the symbols , , , , , , and .in the statusline
    " segments add the following to your .vimrc.before.local file:
    "   let g:airline_powerline_fonts=1
    " If the previous symbols do not render for you then install a
    " powerline enabled font.

    " See `:echo g:airline_theme_map` for some more choices
    " Default in terminal vim is 'dark'
    if isdirectory(expand("~/.vim/plugged/vim-airline-themes/"))
        if !exists('g:airline_theme')
          let g:airline_theme = 'solarized'
        endif
        if !exists('g:airline_powerline_fonts')
          " Use the default set of separators with a few customizations
          let g:airline_left_sep='›'  " Slightly fancier than '>'
          let g:airline_right_sep='‹' " Slightly fancier than '<'
        endif
    endif
  " }
  
  " cscope {
    nnoremap <leader>fa :call CscopeFindInteractive(expand('<cword>'))<CR>
    nnoremap <leader>l :call ToggleLocationList()<CR>
    " s: Find this C symbol
    nnoremap  <leader>fs :call CscopeFind('s', expand('<cword>'))<CR>
    " g: Find this definition
    nnoremap  <leader>fg :call CscopeFind('g', expand('<cword>'))<CR>
    " d: Find functions called by this function
    nnoremap  <leader>fd :call CscopeFind('d', expand('<cword>'))<CR>
    " c: Find functions calling this function
    nnoremap  <leader>fc :call CscopeFind('c', expand('<cword>'))<CR>
    " t: Find this text string
    nnoremap  <leader>ft :call CscopeFind('t', expand('<cword>'))<CR>
    " e: Find this egrep pattern
    nnoremap  <leader>fe :call CscopeFind('e', expand('<cword>'))<CR>
    " f: Find this file
    nnoremap  <leader>ff :call CscopeFind('f', expand('<cword>'))<CR>
    " i: Find files #including this file
    nnoremap  <leader>fi :call CscopeFind('i', expand('<cword>'))<CR>
  " }

  " GoLang {
    if executable('go')
      let g:go_highlight_functions = 1
      let g:go_highlight_methods = 1
      let g:go_highlight_structs = 1
      let g:go_highlight_operators = 1
      let g:go_highlight_build_constraints = 1
      let g:go_fmt_command = "goimports"
      let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
      let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
      au FileType go nmap <Leader>s <Plug>(go-implements)
      au FileType go nmap <Leader>i <Plug>(go-info)
      au FileType go nmap <Leader>e <Plug>(go-rename)
      au FileType go nmap <leader>r <Plug>(go-run)
      au FileType go nmap <leader>b <Plug>(go-build)
      au FileType go nmap <leader>t <Plug>(go-test)
      au FileType go nmap <Leader>gd <Plug>(go-doc)
      au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
      au FileType go nmap <leader>co <Plug>(go-coverage)
      autocmd BufNewFile,BufRead *.go setlocal listchars=tab:\ \ ,trail:·,extends:\#,nbsp:.
    endif
  " }

  " syntastic {
    if isdirectory(expand("~/.vim/plugged/syntastic"))
      set statusline+=%#warningmsg#
      set statusline+=%{SyntasticStatuslineFlag()}
      set statusline+=%*
      let g:syntastic_always_populate_loc_list = 1
      let g:syntastic_auto_loc_list = 1
      let g:syntastic_check_on_open = 1
      let g:syntastic_check_on_wq = 0
    endif
  " }

  " tabular {
    if isdirectory(expand("~/.vim/plugged/tabular"))
      nmap <Leader>a& :Tabularize /&<CR>
      vmap <Leader>a& :Tabularize /&<CR>
      nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
      vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
      nmap <Leader>a=> :Tabularize /=><CR>
      vmap <Leader>a=> :Tabularize /=><CR>
      nmap <Leader>a: :Tabularize /:<CR>
      vmap <Leader>a: :Tabularize /:<CR>
      nmap <Leader>a:: :Tabularize /:\zs<CR>
      vmap <Leader>a:: :Tabularize /:\zs<CR>
      nmap <Leader>a, :Tabularize /,<CR>
      vmap <Leader>a, :Tabularize /,<CR>
      nmap <Leader>a,, :Tabularize /,\zs<CR>
      vmap <Leader>a,, :Tabularize /,\zs<CR>
      nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
      vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    endif
  " }

  " ctrlp {
    if isdirectory(expand("~/.vim/plugged/ctrlp.vim/"))
      let g:ctrlp_working_path_mode = 'ra'
      nnoremap <silent> <C-p> :CtrlP<CR>
      nnoremap <silent> <D-t> :CtrlP<CR>
      nnoremap <silent> <D-r> :CtrlPMRU<CR>
      let g:ctrlp_custom_ignore = {
          \ 'dir':  '\.git$\|\.hg$\|\.svn$',
          \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

      if executable('ag')
        let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
      elseif executable('ack-grep')
        let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
      elseif executable('ack')
        let s:ctrlp_fallback = 'ack %s --nocolor -f'
      " On Windows use "dir" as fallback command.
      elseif WINDOWS()
        let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
      else
        let s:ctrlp_fallback = 'find %s -type f'
      endif
      if exists("g:ctrlp_user_command")
        unlet g:ctrlp_user_command
      endif
      let g:ctrlp_user_command = {
          \ 'types': {
              \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
              \ 2: ['.hg', 'hg --cwd %s locate -I .'],
          \ },
          \ 'fallback': s:ctrlp_fallback
      \ }

      if isdirectory(expand("~/.vim/plugged/ctrlp-funky/"))
        " CtrlP extensions
        let g:ctrlp_extensions = ['funky']
        "funky
        nnoremap <Leader>fu :CtrlPFunky<Cr>
      endif
    endif
  "}

  " TagBar {
    if isdirectory(expand("~/.vim/plugged/tagbar/"))
      nnoremap <silent> <leader>tt :TagbarToggle<CR>
    endif
  "}

  " Session List {
    set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
    if isdirectory(expand("~/.vim/bundle/sessionman.vim/"))
      nmap <leader>sl :SessionList<CR>
      nmap <leader>ss :SessionSave<CR>
      nmap <leader>sc :SessionClose<CR>
    endif
  " }

  " PyMode {
    " Disable if python support not present
    if !has('python') && !has('python3')
      let g:pymode = 0
    endif

    if isdirectory(expand("~/.vim/bundle/python-mode"))
      let g:pymode_lint_checkers = ['pyflakes']
      let g:pymode_trim_whitespaces = 0
      let g:pymode_options = 0
      let g:pymode_rope = 0
    endif
  " }

  " PIV {
    if isdirectory(expand("~/.vim/bundle/PIV"))
      let g:DisableAutoPHPFolding = 0
      let g:PIVAutoClose = 0
    endif
  " }

  " Rainbow {
    if isdirectory(expand("~/.vim/plugged/rainbow/"))
      let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
      let g:rainbow_conf = {
      \     'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
      \     'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
      \     'operators': '_,_',
      \     'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
      \     'separately': {
      \           '*': {},
      \           'tex': {
      \                 'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
      \           },
      \           'lisp': {
      \                 'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
      \           },
      \           'vim': {
      \                 'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
      \           },
      \           'html': {
      \                 'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
      \           },
      \           'css': 0,
      \     }
      \}
    endif
  "}

  " Fugitive {
    if isdirectory(expand("~/.vim/plugged/vim-fugitive/"))
      nnoremap <silent> <leader>gs :Gstatus<CR>
      nnoremap <silent> <leader>gd :Gdiff<CR>
      nnoremap <silent> <leader>gc :Gcommit<CR>
      nnoremap <silent> <leader>gb :Gblame<CR>
      nnoremap <silent> <leader>gl :Glog<CR>
      nnoremap <silent> <leader>gp :Git push<CR>
      nnoremap <silent> <leader>gr :Gread<CR>
      nnoremap <silent> <leader>gw :Gwrite<CR>
      nnoremap <silent> <leader>ge :Gedit<CR>
      " Mnemonic _i_nteractive
      nnoremap <silent> <leader>gi :Git add -p %<CR>
      nnoremap <silent> <leader>gg :SignifyToggle<CR>
      endif
  "}

  " tagbar {
    if isdirectory(expand("~/.vim/plugged/tagbar/"))
      nnoremap <silent> <leader>tt :TagbarToggle<CR>
    endif
  " }

  " nerdcommenter {
    if isdirectory(expand("~/.vim/plugged/nerdcommenter"))
      nnoremap <Leader>cc :NERDComToggleComment<CR>
    endif
  " }

  " NerdTree {
    if isdirectory(expand("~/.vim/plugged/nerdtree"))
      map <C-e>       :NERDTreeToggle<CR>
      map <leader>e   :NERDTreeFind<CR>
      nmap <leader>nt :NERDTreeFind<CR>

      let NERDShutUp=1
      let NERDTreeAutoDeleteBuffer = 1
      let NERDTreeShowBookmarks=1
      let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
      let NERDTreeChDirMode=0
      let NERDTreeQuitOnOpen=0
      let NERDTreeMouseMode=2
      let NERDTreeShowHidden=1
      let NERDTreeKeepTreeInNewTab=1
      let g:nerdtree_tabs_open_on_gui_startup=0

      autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    endif
  " }

  " UndoTree {
    if isdirectory(expand("~/.vim/plugged/undotree/"))
      nnoremap <Leader>u :UndotreeToggle<CR>
      " If undotree is opened, it is likely one wants to interact with it.
      let g:undotree_SetFocusWhenToggle=1
    endif
  " }

  " indent_guides {
    if isdirectory(expand("~/.vim/plugged/vim-indent-guides/"))
      let g:indent_guides_start_level = 2
      let g:indent_guides_guide_size = 1
      let g:indent_guides_enable_on_vim_startup = 1
    endif
  " }
  " slime {
    let g:slime_no_mappings = 1
    let g:slime_paste_file = "/tmp/" . $USER . getpid() . ".slime_paste"
    " vim terminal
    if has('terminal')
      let g:slime_target = "vimterminal"
      let g:slime_vimterminal_config = {
            \ 'term_finish' : "close",
            \ 'term_name': 'REPL' }
    elseif exists('$STY')
      let g:slime_target = "screen"
    elseif exists('$TMUX')
      let g:slime_target = "tmux"
    endif
    " key mapings
    " run code with motion
    nmap      <Leader>r    <Plug>SlimeMotionSend
    " run line
    nmap      <Leader>rl   <Plug>SlimeLineSend
    " run paragraph
    nmap      <Leader>rp   <Plug>SlimeParagraphSend
    " run file
    nnoremap  <Leader>rr   :%SlimeSend<CR>
    " run visual region
    xmap      <Leader>r    <Plug>SlimeRegionSend
    " config
    nmap      <Leader>rc   <Plug>SlimeConfig
  " }

  " YouCompleteMe {
    if isdirectory(expand("~/.vim/plugged/YouCompleteMe/"))
      let g:spf13_ycm_completer = '--clang-completer --go-completer --rust-completer'
      let g:acp_enableAtStartup = 0
      " enable completion from tags
      let g:ycm_collect_identifiers_from_tags_files = 1

      " remap Ultisnips for compatibility for YCM
      let g:UltiSnipsExpandTrigger = '<C-j>'
      let g:UltiSnipsJumpForwardTrigger = '<C-j>'
      let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

      " Enable omni completion.
      autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
      autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
      autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
      autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
      autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
      autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
      autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

      " Haskell post write lint and check with ghcmod
      " $ `cabal install ghcmod` if missing and ensure
      " ~/.cabal/bin is in your $PATH.
      if !executable("ghcmod")
          autocmd BufWritePost *.hs GhcModCheckAndLintAsync
      endif

      " For snippet_complete marker.
      if !exists("g:spf13_no_conceal")
          if has('conceal')
              set conceallevel=2 concealcursor=i
          endif
      endif

      " Disable the neosnippet preview candidate window
      " When enabled, there can be too much visual noise
      " especially when splits are used.
      set completeopt-=preview
    endif
  " }

" }

" Functions {
  " Initialize directories {
  function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
      let dir_list['undo'] = 'undodir'
    endif

    " To specify a different directory in which to place the vimbackup,
    " vimviews, vimundo, and vimswap files/directories, add the following to
    " your .vimrc.before.local file:
    "   let g:spf13_consolidated_directory = <full path to desired directory>
    "   eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
    if exists('g:spf13_consolidated_directory')
      let common_dir = g:spf13_consolidated_directory . prefix
    else
      let common_dir = parent . '/.' . prefix
    endif

    for [dirname, settingname] in items(dir_list)
      let directory = common_dir . dirname . '/'
      if exists("*mkdir")
        if !isdirectory(directory)
          call mkdir(directory)
        endif
      endif
      if !isdirectory(directory)
        echo "Warning: Unable to create backup directory: " . directory
        echo "Try: mkdir -p " . directory
      else
        let directory = substitute(directory, " ", "\\\\ ", "g")
        exec "set " . settingname . "=" . directory
      endif
    endfor
  endfunction
  call InitializeDirectories()
  " }

  " Initialize NERDTree as needed {
  function! NERDTreeInitAsNeeded()
      redir => bufoutput
      buffers!
      redir END
      let idx = stridx(bufoutput, "NERD_tree")
      if idx > -1
        NERDTreeMirror
        NERDTreeFind
        wincmd l
      endif
  endfunction
  " }

  " Strip whitespace {
  function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
  endfunction
  " }

  " Shell command {
  function! s:RunShellCommand(cmdline)
    botright new

    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal noswapfile
    setlocal nowrap
    setlocal filetype=shell
    setlocal syntax=shell

    call setline(1, a:cmdline)
    call setline(2, substitute(a:cmdline, '.', '=', 'g'))
    execute 'silent $read !' . escape(a:cmdline, '%#')
    setlocal nomodifiable
    1
  endfunction

  command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
  " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
  " }

  function! s:IsSpf13Fork()
    let s:is_fork = 0
    let s:fork_files = ["~/.vimrc.fork", "~/.vimrc.before.fork", "~/.vimrc.plugins.fork"]
    for fork_file in s:fork_files
      if filereadable(expand(fork_file, ":p"))
        let s:is_fork = 1
        break
      endif
    endfor
    return s:is_fork
  endfunction

  function! s:ExpandFilenameAndExecute(command, file)
      execute a:command . " " . expand(a:file, ":p")
  endfunction

  function! s:EditSpf13Config()
    call <SID>ExpandFilenameAndExecute("tabedit", "~/.vimrc")
    call <SID>ExpandFilenameAndExecute("vsplit", "~/.vimrc.before")
    call <SID>ExpandFilenameAndExecute("vsplit", "~/.vimrc.plugins")

    execute bufwinnr(".vimrc") . "wincmd w"
    call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.local")
    wincmd l
    call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.before.local")
    wincmd l
    call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.plugins.local")

    if <SID>IsSpf13Fork()
      execute bufwinnr(".vimrc") . "wincmd w"
      call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.fork")
      wincmd l
      call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.before.fork")
      wincmd l
      call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.plugins.fork")
    endif

    execute bufwinnr(".vimrc.local") . "wincmd w"
  endfunction

  execute "noremap " . s:spf13_edit_config_mapping " :call <SID>EditSpf13Config()<CR>"
  execute "noremap " . s:spf13_apply_config_mapping . " :source ~/.vimrc<CR>"
" }

" GUI Settings {
  " GVIM- (here instead of .gvimrc)
  if has('gui_running')
    set guioptions-=T           " Remove the toolbar
    set lines=40                " 40 lines of text instead of 24
    if !exists("g:spf13_no_big_font")
      if LINUX() && has("gui_running")
        set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
      elseif OSX() && has("gui_running")
        set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
      elseif WINDOWS() && has("gui_running")
        set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
      endif
    endif
  else
    if &term == 'xterm' || &term == 'screen'
      set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
    endif
    "set term=builtin_ansi       " Make arrow and other keys work
  endif

" }

" Use local vimrc if available {
    if filereadable(expand("~/.vimrc.local"))
      source ~/.vimrc.local
    endif
" }

" Use local gvimrc if available and gui is running {
  if has('gui_running')
    if filereadable(expand("~/.gvimrc.local"))
      source ~/.gvimrc.local
    endif
  endif
" }
