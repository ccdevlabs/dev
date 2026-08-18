return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",
  },
  config = function()
    local telescope = require('telescope')
    telescope.setup({
      defaults = require('telescope.themes').get_ivy {},
      extensions = {
        ['ui-select'] = {
          require("telescope.themes").get_dropdown(),
        }
      }
    })

    telescope.load_extension('fzf')
    telescope.load_extension('ui-select')

    local builtin = require('telescope.builtin')
    local set = vim.keymap.set

    set('n', '<leader>pf', builtin.find_files, { desc = "Search [P]roject [F]iles" })
    set('n', '<C-p>', builtin.git_files, { desc = "[P]roject Git Files" })
    set('n', '<leader>vh', builtin.help_tags, { desc = "[V]iew [H]elp" })
    set('n', '<leader>vc', function()
      builtin.find_files {
        cwd = vim.fn.stdpath('config')
      }
    end)

    require('devcc.config.telescope.livegrep').setup()
  end
}
