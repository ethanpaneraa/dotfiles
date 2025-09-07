return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      position = "right",
    },
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      -- Make filtered items look like normal items
      vim.api.nvim_set_hl(0, "NeoTreeFilterTerm", { link = "NeoTreeFileName" })
      vim.api.nvim_set_hl(0, "NeoTreeDimText", { link = "NeoTreeFileName" })
    end,
  },
}
