return {
  "kawre/leetcode.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    -- "ibhagwan/fzf-lua",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  enabled = function()
    local cwd = vim.fn.getcwd()
    return cwd:match("leetcode") ~= nil
  end,
  opts = {
    -- configuration goes here
    lang = "typescript",
    storage = {
      home = vim.fn.expand("~") .. "/personal/leetcode",
      cache = vim.fn.expand("~") .. "/personal/leetcode/.cache",
    },
    injector = {
      ["typescript"] = {
        before = { '/// <reference path="./global.d.ts" />' },
      },
    },
  },
  config = function(_, opts)
    vim.keymap.set("n", "<leader>st", "<cmd>Leet test<cr>")
    vim.keymap.set("n", "<leader>s<CR>", "<cmd>Leet submit<cr>")
    vim.keymap.set("n", "<leader>ps", "<cmd>Leet list<cr>")
    require("leetcode").setup(opts)
  end,
}
