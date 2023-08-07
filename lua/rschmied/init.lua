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
    -- "folke/which-key.nvim",
    -- { "folke/neoconf.nvim", cmd = "Neoconf" },
    { "folke/neodev.nvim" },

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
    { "catppuccin/nvim",  name = "catppuccin" },
    {
        "AlexvZyl/nordic.nvim",
        name = "nordic",
        config = function()
            vim.cmd("colorscheme nordic")
        end
    },
    { "folke/tokyonight.nvim",           name = "tokyo" },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-treesitter/playground" },
    { "theprimeagen/harpoon" },
    { "mbbill/undotree" },
    { "tpope/vim-fugitive" },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
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
    { "terrortylor/nvim-comment" },
    {
        "NvChad/nvterm",
        config = function()
            require("nvterm").setup()
        end,
    },
    -- nvtree
    { "nvim-tree/nvim-tree.lua" },
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-lualine/lualine.nvim" },
    {
        "lewis6991/gitsigns.nvim",
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
    {
        "lukas-reineke/indent-blankline.nvim",
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
    {
        "akinsho/bufferline.nvim",
        config = function()
            require('bufferline').setup({
                options = {
                    mode = 'buffers',
                    offsets = {
                        { filetype = 'NvimTree' }
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
})

vim.opt.showmode = false

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

local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({ buffer = bufnr })
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()


require('nvim_comment').setup({
    -- Linters prefer comment and line to have a space in between markers
    marker_padding = true,
    -- should comment out empty or whitespace only lines
    comment_empty = true,
    -- trim empty comment whitespace
    comment_empty_trim_whitespace = true,
    -- Should key mappings be created
    create_mappings = true,
    -- Normal mode mapping left hand side
    line_mapping = "gcc",
    -- Visual/Operator mapping left hand side
    operator_mapping = "gc",
    -- text object mapping, comment chunk,,
    comment_chunk_text_object = "ic",
    -- Hook function to call before commenting takes place
    hook = nil
})


print("hello")
