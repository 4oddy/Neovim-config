set mouse=a "enable mouse
set encoding=utf-8
set number
set relativenumber
set cursorline
set noswapfile
set scrolloff=7

"tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set fileformat=unix

set splitbelow
set splitright

" Ctrl + l to enable autocomplete (coc disabled)
" inoremap <silent><expr> <C-l> coc#refresh()

call plug#begin('~/.vim/plugged')

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'fannheyward/coc-pyright'

Plug 'nvim-treesitter/nvim-treesitter'
Plug 'ray-x/lsp_signature.nvim'

" autocomplete
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

" colorscheme
Plug 'morhetz/gruvbox' "colorscheme gruvbox

call plug#end()

let mapleader = ","

" turn off search highlight
nnoremap ,<space> :nohlsearch<CR>

colorscheme gruvbox

lua << EOF
-- In your Neovim configuration file (e.g., init.lua)
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Autocomplete settings
local cmp = require('cmp')
cmp.setup({
  completion = {
    autocomplete = false, -- Отключить автоматическое появление
  },
  mapping = {
    ['<C-k>'] = cmp.mapping.complete(), -- Вызов меню автокомплита
    ['<C-e>'] = cmp.mapping.abort(), -- Закрыть меню
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Подтвердить выбор
    ['<C-p>'] = cmp.mapping.select_prev_item(), -- Навигация вверх
    ['<C-n>'] = cmp.mapping.select_next_item(), -- Навигация вниз
  },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },  -- Источник из LSP
    }),
})


-- LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local on_attach = function(client, bufnr)

    -- Быстрые команды для LSP
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)

    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-c>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
    require "lsp_signature".on_attach({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      floating_window = true,
      floating_window_above_cur_line = true,
      floating_window_off_x = 20,
      doc_lines = 10,
      hint_prefix = '👻 '
    }, bufnr)  -- Note: add in lsp client on-attach
end

-- pyright
vim.lsp.config("pyright", {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
            },
        },
    },
})
vim.lsp.enable("pyright")

-- clangd
vim.lsp.enable('clangd')

vim.diagnostic.config({
  virtual_text = true,
  signs = true,        
  underline = true,
  update_in_insert = true,
})

--vim.api.nvim_create_autocmd('FileType', {
--  pattern = { '<.py>' },
--  callback = function() vim.treesitter.start() end,
--})


--vim.treesitter.start()

EOF
