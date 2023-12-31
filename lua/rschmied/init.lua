require("rschmied.set")
require("rschmied.remap")

-- https://vonheikemen.github.io/devlog/tools/neovim-plugins-to-get-started/


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
    -- { "folke/neoconf.nvim", cmd = "Neoconf" },
    { "folke/neodev.nvim" },

    -- UI window dressing
    --[[ {
        "stevearc/dressing.nvim",
        lazy = false,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    }, ]]

    -- session management
    {
        "folke/persistence.nvim",
        event = "BufReadPre", -- this will only start session saving when an actual file was opened
        opts = {
            -- add any custom options here
            options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" }
        },
        keys = {
            {
                -- restore the session for the current directory
                "<leader>qs",
                "[[<cmd>lua require('persistence').load()<cr>]]",
                desc = "load session for current dir"
            },
            {
                -- restore the last session
                "<leader>ql",
                "[[<cmd>lua require('persistence').load({ last = true })<cr>]]",
                desc = "restore the last session"
            },
            {
                -- stop Persistence => session won't be saved on exit
                "<leader>qd",
                "[[<cmd>lua require('persistence').stop()<cr>]]",
                desc = "stop persistence, no session save"
            },
        }
    },

    -- Telescpe related
    {
        "nvim-telescope/telescope.nvim",
        version = "0.1.2",
        dependencies = { { "nvim-lua/plenary.nvim" } }
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
        config = function()
            require("telescope").load_extension("fzf")
        end
    },

    -- color themes
    { "catppuccin/nvim",  lazy = true, name = "catppuccin" },
    {
        "AlexvZyl/nordic.nvim",
        name = "nordic",
        config = function()
            vim.cmd("colorscheme nordic")
        end
    },
    { "folke/tokyonight.nvim",           lazy = true,        name = "tokyo" },

    -- treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-treesitter/playground",      lazy = true },

    -- misc
    { "theprimeagen/harpoon",            lazy = true },
    { "mbbill/undotree",                 lazy = false },
    { "tpope/vim-fugitive",              lazy = false },

    -- LSP zero
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        lazy = true,
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- Required
            { 'williamboman/mason.nvim' },           -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        }
    },

    -- code comment function
    {
        'numToStr/Comment.nvim',
        lazy = false,
        config = function()
            require('Comment').setup(
                {
                    ---Add a space b/w comment and the line
                    padding = true,
                    ---Whether the cursor should stay at its position
                    sticky = true,
                    ---Lines to be ignored while (un)comment
                    ignore = nil,
                    ---LHS of toggle mappings in NORMAL mode
                    toggler = {
                        ---Line-comment toggle keymap
                        line = 'gcc',
                        ---Block-comment toggle keymap
                        block = 'gbc',
                    },
                    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
                    opleader = {
                        ---Line-comment keymap
                        line = 'gc',
                        ---Block-comment keymap
                        block = 'gb',
                    },
                    ---LHS of extra mappings
                    extra = {
                        ---Add comment on the line above
                        above = 'gcO',
                        ---Add comment on the line below
                        below = 'gco',
                        ---Add comment at the end of line
                        eol = 'gcA',
                    },
                    ---Enable keybindings
                    ---NOTE: If given `false` then the plugin won't create any mappings
                    mappings = {
                        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
                        basic = true,
                        ---Extra mapping; `gco`, `gcO`, `gcA`
                        extra = true,
                    },
                    ---Function to call before (un)comment
                    pre_hook = nil,
                    ---Function to call after (un)comment
                    post_hook = nil,
                })
        end
    },

    -- nvchad terminal
    {
        "NvChad/nvterm",
        lazy = true,
        config = function()
            require("nvterm").setup({
                terminals = {
                    shell = vim.o.shell,
                    list = {},
                    type_opts = {
                        float = {
                            relative = 'editor',
                            row = 0.3,
                            col = 0.25,
                            width = 0.5,
                            height = 0.4,
                            border = "single",
                        },
                        horizontal = { location = "rightbelow", split_ratio = .3, },
                        vertical = { location = "rightbelow", split_ratio = .5 },
                    }
                },
                behavior = {
                    autoclose_on_quit = {
                        enabled = false,
                        confirm = true,
                    },
                    close_on_exit = true,
                    auto_insert = true,
                },
            })
        end,
    },
    -- nvtree
    -- { "nvim-tree/nvim-tree.lua",     lazy = true },
    -- { "nvim-tree/nvim-web-devicons", lazy = true },

    -- fancy status bar
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'onedark',
                    icons_enabled = true,
                    component_separators = '|',
                    section_separators = '',
                    disabled_filetypes = {
                        statusline = { 'NvimTree' }
                    }
                },
            })
        end
    },

    -- git status in gutter
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        config = function()
            require('gitsigns').setup({
                signs = {
                    add = { text = '▎' },
                    change = { text = '▎' },
                    delete = { text = '➤' },
                    topdelete = { text = '➤' },
                    changedelete = { text = '▎' },
                }
            })
        end
    },

    -- show indent lines
    {
        "lukas-reineke/indent-blankline.nvim",
        lazy = false,
        config = function()
            require('indent_blankline').setup({
                char = '▏',
                show_trailing_blankline_indent = false,
                show_first_indent_level = true,
                use_treesitter = true,
                show_current_context = true
            })
        end
    },

    -- show tabs on top
    {
        "akinsho/bufferline.nvim",
        config = function()
            require('bufferline').setup({
                options = {
                    -- diagnostics = "nvim_lsp",

                    mode = 'buffers',
                    -- diagnostics_indicator = function(_, _, diag)
                    --     local icons = require("lazyvim.config").icons.diagnostics
                    --     local ret = (diag.error and icons.Error .. diag.error .. " " or "")
                    --         .. (diag.warning and icons.Warn .. diag.warning or "")
                    --     return vim.trim(ret)
                    -- end,
                    offsets = {
                        {
                            filetype = "neo-tree",
                            text = "Neo-tree",
                            highlight = "Directory",
                            text_align = "left",
                        },
                    },
                },
                highlights = {
                    buffer_selected = {
                        italic = false
                    },
                    indicator_selected = {
                        fg = { attribute = 'fg', highlight = 'Function' },
                        italic = false
                    }
                }
            })
        end
    },

    -- filesystem explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        keys = {
            { "<leader>ft", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
        },
        lazy = true,
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        opts = {
            sources = { "filesystem", "buffers", "git_status", "document_symbols" },
            open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
            filesystem = {
                bind_to_cwd = false,
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
            },
            window = {
                mappings = {
                    ["<space>"] = "none",
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
            },
        }
    }
})

vim.opt.showmode = false

require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    -- sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (for "all")
    -- ignore_install = { "javascript" },

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        -- disable = { "c", "rust" },
        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
        -- disable = function(lang, buf)
        --     local max_filesize = 100 * 1024 -- 100 KB
        --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        --     if ok and stats and stats.size > max_filesize then
        --         return true
        --     end
        -- end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}

-- LSP Zero specific
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({
        buffer = bufnr,
        preserve_mappings = true
    })
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

-- You need to setup `cmp` after lsp-zero
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
    mapping = {
        -- `Enter` key to confirm completion
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        -- Ctrl+Space to trigger completion menu
        ['<C-Space>'] = cmp.mapping.complete(),

        -- Navigate between snippet placeholder
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    }
})

print("hello")
