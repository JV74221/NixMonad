" ------------------------------------------------------------------------------
"  Plugins
" ------------------------------------------------------------------------------

call plug#begin()
Plug 'lambdalisue/suda.vim'
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'vim-scripts/AutoComplPop'
Plug 'jiangmiao/auto-pairs'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'preservim/nerdtree'
Plug 'NLKNguyen/papercolor-theme'
call plug#end()

" ------------------------------------------------------------------------------
"  General
" ------------------------------------------------------------------------------

" Enable mouse support.
set mouse=a

" Enable system clipboard support.
set clipboard+=unnamedplus

" Enable line numbers.
set number

" Highlight current line.
set cursorline

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
set smartcase

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=3

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" Turn backup off.
" set nobackup
" set nowritebackup
" set noswapfile

" Turn on auto completion.
set complete+=kspell
set completeopt=menuone,longest

" Don't show the status of autocompletion in status line.
set shortmess+=c

" Make the 81st column stand out.
call matchadd('ColorColumn', '\%81v.', 100)

" Highlight unwanted characters.
exec "set listchars=tab:\uBB\uBB,trail:\uB7"
set list

" ------------------------------------------------------------------------------
"  Plugin: sheerun/vim-polyglot (Indentation)
" ------------------------------------------------------------------------------

" Set tab width to N columns.
" set tabstop=2

" Set shift width to N spaces.
" set shiftwidth=2

" Use space characters instead of tabs.
" set expandtab

" Set indentation according to the filetype.
" autocmd Filetype py setlocal tabstop=4 shiftwidth=4 expandtab

" ------------------------------------------------------------------------------
"  Plugin: TNLKNguyen/papercolor-theme
" ------------------------------------------------------------------------------

" PaperColor Customization
let g:PaperColor_Theme_Options = {
      \  'theme': {
        \    'default': {
          \      'allow_bold': 1,
          \      'allow_italic': 1
          \    }
          \  }
          \}

" Enables 24-bit RGB color in the Terminal UI.
set termguicolors

" Set background color for the theme.
set background=dark

" Set the default theme.
colorscheme PaperColor

" Force to use underline for spell check results.
highlight SpellBad cterm=underline gui=underline guifg=NONE guibg=NONE
highlight SpellLocal cterm=underline gui=underline guifg=NONE guibg=NONE
highlight SpellRare cterm=underline gui=underline guifg=NONE guibg=NONE
highlight SpellCap cterm=underline gui=underline guifg=NONE guibg=NONE

" ------------------------------------------------------------------------------
"  Plugin: lambdalisue/suda.vim 
" ------------------------------------------------------------------------------

" Enable smart edit for the suda plugin.
let g:suda_smart_edit = 1

" ------------------------------------------------------------------------------
"  Plugin: preservim/nerdtree
" ------------------------------------------------------------------------------

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 &&
  \  winnr('$') == 1 &&
  \  exists('b:NERDTree') &&
  \  b:NERDTree.isTabTree() | quit | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 &&
  \ exists('b:NERDTree') &&
  \ b:NERDTree.isTabTree() | quit | endif

" ------------------------------------------------------------------------------
"  Plugin: norcalli/nvim-colorizer.lua
" ------------------------------------------------------------------------------

" Enable colorizer.lua plugin.
lua require'colorizer'.setup()

" ------------------------------------------------------------------------------
"  Status Line
" ------------------------------------------------------------------------------

" Clear status line when init.vim is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F\ %M\ \(%l\,%c\)\ %y\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=\ \(%b\,0x%B)\ \[%p%%\]

" ------------------------------------------------------------------------------
"  Mappings
" ------------------------------------------------------------------------------

" Spell Checking
nmap <c-s> :setlocal spell!<cr>

" NERDTree
nmap <c-b> :NERDTreeToggle<cr>

" Tabs (Default Keybinding: tn, tj, tk, tc)
nmap tn :tabnew<cr>
nmap tj :tabnext<cr>
nmap tk :tabprevious<cr>
nmap tc :tabclose<cr>

" Windows (Default Keybinding: CTRL+j, k, h, l)
" nmap <c-j> <c-w>j
" nmap <c-k> <c-w>k
" nmap <c-h> <c-w>h
" nmap <c-l> <c-w>l

" Resize Windows (Default Keybinding: CTRL+up, down, left, right)
" nmap <c-up> <c-w>+
" nmap <c-down> <c-w>-
" nmap <c-left> <c-w>>
" nmap <c-right> <c-w><

" Comment/Uncomment (Default Keybinding: CTRL+/)
imap <c-_> <Esc>gccgi
nmap <c-_> gcc
vmap <c-_> gc

" Move Lines (Default Keybinding: ALT+j, k)
" imap <a-j> <Esc>:m+1<cr>==gi
" imap <a-k> <Esc>:m-2<cr>==gi
nmap K :m-2<cr>==
nmap J :m+1<cr>==
vmap K :m'>+1<CR>gv=gv
vmap J :m'<-2<CR>gv=gv

" Copy Lines (Default Keybinding: ALT+SHIFT+j, k)
" nmap <a-s-j> :copy.<cr>==
" nmap <a-s-k> :copy-1<cr>==
" imap <a-s-j> <Esc>:copy.<cr>==gi
" imap <a-s-k> <Esc>:copy-1<cr>==gi
" vmap <a-s-j> :copy'>.<CR>gv=gv
" vmap <a-s-k> :copy'<-1<CR>gv=gv

" New Lines
nmap o o<esc>
nmap O O<esc>

" Toggle Wrap (Default Keybinding: ALT+z)
nmap <a-z> :set wrap!<cr>

" ------------------------------------------------------------------------------
"  Vimsripts
" ------------------------------------------------------------------------------

" This will enable code folding.
" Use the marker method of folding.
" augroup filetype_vim
"     autocmd!
"     autocmd FileType vim setlocal foldmethod=marker
" augroup END


