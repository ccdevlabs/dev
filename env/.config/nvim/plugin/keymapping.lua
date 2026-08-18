local set = vim.keymap.set
local k = vim.keycode

set("n", "<leader>pv", vim.cmd.Ex)

set("v", "J", ":m '>+1<CR>gv=gv")
set("v", "K", ":m '<-2<CR>gv=gv")

set("n", "J", "mzJ`z")
set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

set("x", "<leader>p", [["_dP]])

set({ "n", "v" }, "<leader>y", [["+y]])
set("n", "<leader>Y", [["+Y]])
set({ "n", "v" }, "<leader>d", [["_d]])

set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

set("i", "<C-c>", "<Esc>")
set("n", "Q", "<nop>")
set("n", "<leader>f", vim.lsp.buf.format)

set("n", "<C-k>", "<cmd>cprev<CR>zz")
set("n", "<C-j>", "<cmd>cnext<CR>zz")
set("n", "<leader>k", "<cmd>lprev<CR>zz")
set("n", "<leader>j", "<cmd>lnext<CR>zz")

set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

set("n", "<leader><leader>", function()
  vim.cmd("w")
end)

set("n", "<leader>sa", "ggVG", { desc = "Select all" })

set("n", "<CR>", function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.v.hlsearch == 1 then
    vim.cmd.nohl()
    return ""
  else
    return k("<CR>")
  end
end, { expr = true })
