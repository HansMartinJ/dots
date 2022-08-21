lua << EOF
local home = os.getenv("HOME")
local share = os.getenv("XDG_DATA_HOME")
vim.opt.tabstop=4 
vim.opt.softtabstop=4
vim.opt.shiftwidth=4
vim.opt.expandtab=true
vim.opt.smartindent=true
vim.opt.relativenumber=true
vim.opt.nu=true
vim.opt.hlsearch=false
vim.opt.hidden=true
vim.opt.errorbells=false
vim.opt.incsearch=true
vim.opt.scrolloff=8
vim.opt.signcolumn="yes"

vim.opt.backup=false
vim.opt.wrap=false
vim.opt.wrapscan=false
vim.opt.swapfile=false
vim.opt.undodir= share .. "/share/nvim/undodir"
vim.opt.undofile=true
vim.opt.undolevels=1000
vim.opt.undoreload=10000
vim.opt.cmdheight=2
vim.opt.updatetime=50
vim.opt.colorcolumn="90"
vim.opt.isfname:remove({"="})

vim.g.mapleader = " "
vim.g.tex_flavor = "latex"

vim.g.neovide_cursor_trail_size=0
vim.opt.guifont="Iosevka:h11"

vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

require("impatient")
require("plugins")
-- vim.api.nvim_set_keymap('n', '<Leader>w', ':write<CR>', {noremap = true})
EOF

set termguicolors
set background=dark " or light if you want light mode
colorscheme gruvbox " catppuccin tokyonight

nnoremap Y y$
nnoremap <BS> <C-^>
nnoremap U <C-r>
noremap <Tab> >>
noremap <S-TAB> <<

nnoremap x "_x
nnoremap c "_c
nnoremap s "_s
vnoremap p "_dP

nnoremap <leader>p "+p
vnoremap <Leader>p "+p
nnoremap <Leader>y "+y
vnoremap <leader>y "+y
nnoremap <Leader>e :Explore<CR>
nnoremap <leader>. :cd %:p:h<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

tnoremap <C-j> <C-\><C-n>

map ø ;
map Ø ,

map j <Nop>
map h <Nop>
map k <Nop>
map l <Nop>

nnoremap h <C-d>
nnoremap l <C-u>

nnoremap ZZ :bd<CR>


command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

"The primeagen
noremap n nzzzv
noremap N Nzzzv
noremap J mzJ'z

inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u

inoremap <C-s> <C-O>:w<CR>
inoremap <C-S> <C-O>:w<CR>
inoremap <C-q> <C-O>:q<CR>
inoremap <C-Q> <C-O>:q!<CR>

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap <C-s> :s//g<Left><Left>
nnoremap <C-s> :%s//g<Left><Left>

" Autocommands
augroup bufwritepost
    autocmd!
    autocmd BufWritePost *.ms :silent !$([ -f Makefile ] &&  make || groff -ms -k -Tpdf % > %.pdf) &
    autocmd BufWritePost *.md :silent !$(pandoc --to html --self-contained % > %:r.html) &
    autocmd BufWritePost *.ts :silent !$(tsc %) &
    autocmd BufWritePost *.tex :silent !$([ -f Makefile ] &&  make || pdflatex %) &
augroup END

augroup bufenter
    autocmd!
    autocmd BufEnter diary.wiki VimwikiDiaryGenerateLinks
augroup END

augroup tex
    autocmd!
    autocmd Filetype tex vnoremap <Leader>b xi\textbf{}<Esc>P
    autocmd Filetype tex nnoremap <Leader>m a$$<Left>
    autocmd Filetype tex nnoremap <Leader>o :!(xdg-open out/*.pdf) & <CR>
    autocmd Filetype tex :setlocal spell
augroup END

augroup remember_folds
  autocmd!
  autocmd BufWinLeave init.vim mkview
  autocmd BufWinEnter init.vim silent! loadview
augroup END

augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual",timeout=200})
augroup END

" Plugin stuff

" Completion
" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
set completeopt=menuone,noinsert,noselect " Set completeopt to have a better completion experience
set shortmess+=c " Avoid showing message extra message when using completion
" Telescope
nnoremap <leader>ff :Telescope find_files<CR>
nnoremap <leader>fg :Telescope live_grep<CR>
nnoremap <leader>fb :Telescope buffers<CR>
nnoremap <leader>fh :Telescope help_tags<CR>
nnoremap <Leader>fc :Telescope find_files find_command=rg,--hidden,--files<CR>
" Undotree
nnoremap <leader>tu :UndotreeToggle<CR>
" ZenMode
nnoremap <leader>tz :ZenMode<CR>
" Git (fugitive)
nnoremap <Leader>gl :G log --graph --decorate --oneline --all<CR>
nnoremap <Leader>gg :G<CR>
nnoremap <Leader>g. :G add .<CR>
nnoremap <Leader>g% :G add %<CR>
nnoremap <Leader>gc :G commit<CR>
nnoremap <Leader>gs :G status<CR>
" Dial
nmap + <Plug>(dial-increment)
nmap - <Plug>(dial-decrement)
" Julia
let g:latex_to_unicode_auto = 1

"#Magma
let g:magma_automatically_open_output = v:false
augroup magma
    autocmd!
    autocmd Filetype julia nnoremap <silent> <Leader>rr :MagmaEvaluateLine<CR>
    autocmd Filetype julia xnoremap <silent> <Leader>r  :<C-u>MagmaEvaluateVisual<CR>
    autocmd Filetype julia nnoremap <silent> <Leader>rc :MagmaReevaluateCell<CR>
    autocmd Filetype julia nnoremap <silent> <Leader>rd :MagmaDelete<CR>
    autocmd Filetype julia nnoremap <silent> <Leader>ro :MagmaShowOutput<CR>
augroup END

" #Sandwich
" let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
" let g:sandwich#recipes += [{'buns': ['"""', '"""'], 'filetype': ['python'], 'nesting': 0, 'input': ['#']}]
