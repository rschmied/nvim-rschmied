local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "find buffers" })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "find files" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "live grep" })
vim.keymap.set('n', '<leader>fG', builtin.git_files, { desc = "find git files" })
vim.keymap.set('n', '<leader>fs',
    function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end,
    { desc = "grep string" }
)
