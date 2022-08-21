
NVIMCONF = os.getenv("XDG_CONFIG_HOME") .. "/nvim"
NVIMDATA = os.getenv("XDG_DATA_HOME") .. "/nvim"

function LOG(str)
    local mydebug = io.open(NVIMCONF .. "/custom/log", "a")
    if mydebug == nil then
        return
    end
    mydebug:write(str .. "\n")
    mydebug:flush()
    mydebug:close()
end

local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

return require('packer').startup(function(use) --local vim = require"vim"

    use {
      'phaazon/hop.nvim',
      branch = 'v2', -- optional but strongly recommended
      config = function()
        local hop = require'hop'
        hop.setup {}
        vim.api.nvim_set_keymap('', 'k', "", {callback = function() hop.hint_lines_skip_whitespace({direction=require'hop.hint'.HintDirection.BEFORE_CURSOR}) end})
        vim.api.nvim_set_keymap('', 'j', "", {callback = function() hop.hint_lines_skip_whitespace({direction=require'hop.hint'.HintDirection.AFTER_CURSOR}) end})
      end
    }
    use { 'lewis6991/impatient.nvim' }
    use { "nathom/filetype.nvim" }

    use { 'wbthomason/packer.nvim' }


    use { 'tpope/vim-fugitive' }
    use { 'JuliaEditorSupport/julia-vim' }
    use { 'https://github.com/vimwiki/vimwiki' }
    use { "wellle/targets.vim" }
    use { 'marko-cerovac/material.nvim' }
    use { 'folke/tokyonight.nvim' }
    use { "ellisonleao/gruvbox.nvim", requires = { "rktjmp/lush.nvim" } }
    use { 'kmonad/kmonad-vim' }
    use { 'dccsillag/magma-nvim', opt=false, run = ':UpdateRemotePlugins' }
    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        config = function()
            require 'nvim-treesitter.configs'.setup {
                textobjects = {
                    select = {
                        enable = true,
                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<C-l>"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<C-h>"] = "@parameter.inner",
                        },
                    },
                },
            }
        end
    }
    use {
        'monaqa/dial.nvim',
        config = function()
            local augend = require("dial.augend")
            require("dial.config").augends:register_group {
                default = {
                    augend.integer.alias.decimal,
                    augend.constant.alias.bool,
                    augend.constant.new {
                        elements = { "True", "False" },
                        word = true,
                        cyclic = true,
                    },
                    augend.constant.new {
                        elements = { "and", "or" },
                        word = true,
                        cyclic = true,
                    },
                    augend.constant.new {
                        elements = { "&&", "||" },
                        word = false,
                        cyclic = true,
                    },
                    augend.date.alias["%Y/%m/%d"],
                },
            }
        end
    }

    use {
        'folke/which-key.nvim',
        config = function()
            require("which-key").setup {}
        end
    }
    use {
        'numToStr/Comment.nvim', config = function() require('Comment').setup() end
    }
    use {
        'hoschi/yode-nvim',
        config = function()
            require('yode-nvim').setup {}
        end
    }
    use {
        'windwp/nvim-autopairs',
        config = function() require 'nvim-autopairs'.setup() end,
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/popup.nvim', opt = false }, { 'nvim-lua/plenary.nvim', opt = false } },
        config = function()
            require 'telescope'.setup {
                file_ignore_patterns = { "*.ipynb","*.png","*.jpg","*.mp3","*.pdf"}
            }
        end,
    }
    use {
        'mbbill/undotree',
        opt = true,
        cmd = "UndotreeToggle",
        config = function() end,
    }
    use {
        'folke/zen-mode.nvim',
        config = function()
            require('zen-mode').setup()
        end,
        opt = true,
        cmd = "ZenMode",
    }
    use { 'L3MON4D3/LuaSnip' }
    use { 'saadparwaiz1/cmp_luasnip' }
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            { 'hrsh7th/cmp-nvim-lua', opt = false, },
            { 'hrsh7th/cmp-nvim-lsp', opt = false },
            { 'hrsh7th/cmp-buffer', opt = false },
            { 'hrsh7th/cmp-path', opt = false, },
            { 'hrsh7th/cmp-cmdline', opt = false },
        },
        config = function()
            local cmp = require 'cmp'
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require 'luasnip'.lsp_expand(args.body)
                    end
                },
                sources = {
                    { name = 'nvim_lua' },
                    { name = 'path' },
                    { name = 'luasnip' },
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                },
                mapping = {
                    ["<Tab>"] = cmp.mapping({
                        c = function()
                            if cmp.visible() then
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                            else
                                cmp.complete()
                            end
                        end,
                        i = function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                            elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                                vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
                            else
                                fallback()
                            end
                        end,
                        s = function(fallback)
                            if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                                vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
                            else
                                fallback()
                            end
                        end
                    }),
                    ["<S-Tab>"] = cmp.mapping({
                        c = function()
                            if cmp.visible() then
                                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                            else
                                cmp.complete()
                            end
                        end,
                        i = function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                            elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                                return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
                            else
                                fallback()
                            end
                        end,
                        s = function(fallback)
                            if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                                return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
                            else
                                fallback()
                            end
                        end
                    }),
                    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
                    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
                    ['<C-n>'] = cmp.mapping({
                        c = function()
                            if cmp.visible() then
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                            else
                                vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
                            end
                        end,
                        i = function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                            else
                                fallback()
                            end
                        end
                    }),
                    ['<C-p>'] = cmp.mapping({
                        c = function()
                            if cmp.visible() then
                                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                            else
                                vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
                            end
                        end,
                        i = function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                            else
                                fallback()
                            end
                        end
                    }),
                    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
                    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
                    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(nil), {'i', 'c'}),
                    ['<C-e>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
                    ['<CR>'] = cmp.mapping({
                        i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
                        c = function(fallback) fallback() end
                    }),
                }})
            cmp.setup.cmdline(':', {
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                })
            })
        end

    }
    use {
        'williamboman/nvim-lsp-installer',
        config = function()
            require 'nvim-lsp-installer'.setup { automatic_installation = true, }
        end
    }
    use {
        'neovim/nvim-lspconfig',
        config = function()
            local on_attach = function(client, bufnr)
                local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

                local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

                -- Enable completion triggered by <c-x><c-o>
                buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

                -- Mappings.
                local opts = { noremap = true, silent = true }

                -- See `:help vim.lsp.*` for documentation on any of the below functions
                buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
                buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
                buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
                -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
                buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
                buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
                buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
                buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
                buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
                buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
                buf_set_keymap('n', '<space>ac', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
                buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
                buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
                buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
                buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
                buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
                buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

            end
            local lspconfig = require 'lspconfig'

            lspconfig.pyright.setup { on_attach = on_attach }

            local runtime_path = vim.split(package.path, ';')
            table.insert(runtime_path, "lua/?.lua")
            table.insert(runtime_path, "lua/?/init.lua")
            lspconfig.sumneko_lua.setup {
                cmd = { NVIMDATA .. "/nvim/lsp_servers/sumneko_lua/extension/server/bin/lua-language-server" },
                on_attach = on_attach,
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT', -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                            path = runtime_path, -- Setup your lua path
                        },
                        diagnostics = {
                            globals = { 'vim' }, -- Get the language server to recognize the `vim` global
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true), -- Make the server aware of Neovim runtime files
                        },
                    },
                },
            }
            lspconfig.julials.setup { on_attach = on_attach,
                -- cmd = {
                --     "juliad",
                --     getnvimenv() .. "/custom/runjuliaserver.jl"
                --     -- "--trace-compile=" .. getnvimenv() .. "/custom/juliaservertracecompile.jl",
                -- }
            }
            lspconfig.tsserver.setup { on_attach = on_attach }
        end
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
                ignore_install = {}, -- List of parsers to ignore installing
                highlight = {
                    enable = true, -- false will disable the whole extension
                    disable = {}, -- list of language that will be disabled
                    additional_vim_regex_highlighting = false,
                },
            }
        end
    }
end)
-- use {
--     'rmagatti/auto-session',
--     config = function() require('auto-session').setup {
--             log_level = 'info',
--             auto_session_suppress_dirs = {'~/'}
--         }
--     end
-- }
