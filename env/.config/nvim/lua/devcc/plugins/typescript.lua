return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {},
  config = function()
    local opts = { noremap = true, silent = true }
    local on_attach = function(client, bufnr)
      opts.buffer = bufnr
      opts.desc = "sorts and removes unused imports"
      vim.keymap.set("n", "<leader>to", "<cmd>TSToolsOrganizeImports<CR>", opts)
    end
    require("typescript-tools").setup({
      on_attach = on_attach,
    })
  end,
}
