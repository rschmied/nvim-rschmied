-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

-- vim.keymap.set("n", "<leader>e", vim.cmd.NvimTreeToggle, { desc = "toggle NvimTree" })
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- visual block move up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move block up" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move block down" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "join lines but cursor stays" })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- disable certain key bindings
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<up>", "<nop>")
vim.keymap.set("n", "<down>", "<nop>")
vim.keymap.set("n", "<left>", "<nop>")
vim.keymap.set("n", "<right>", "<nop>")

-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- terminal related bindings
vim.keymap.set("n", "<leader>t", function()
    require("nvterm.terminal").toggle "horizontal"
end, { desc = "toggle horizontal terminal" })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "fuGITive" })
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "undo tree toggle" })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "code actions" })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "format code" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "rename symbol under cursor" })
vim.keymap.set("n", "<leader>cs", vim.lsp.buf.signature_help, { desc = "signature help" })
