-- return {
--   "rose-pine/neovim",
--   name = "rose-pine",
--   config = function()
--     vim.cmd("colorscheme rose-pine")
--   end,
-- }
-- return {
--   "rebelot/kanagawa.nvim",
--   name = "kanagawa",
--   priority = 1000,
--   config = function()
--     -- kanagawa-wave kanagawa-dragon kanagawa-lotus
--     vim.cmd.colorscheme("kanagawa-dragon")
--   end,
-- }
return {
  "sainnhe/everforest",
  lazy = false,
  priority = 1000,
  config = function()
    -- Optionally configure and load the colorscheme
    -- directly inside the plugin declaration.
    vim.g.everforest_background = "hard"
    vim.g.everforest_enable_italic = true
    vim.cmd.colorscheme("everforest")
  end,
}
