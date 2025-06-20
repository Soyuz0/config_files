return {
  'ThePrimeagen/harpoon',
  config = function()
    local mark = require 'harpoon.mark'
    local ui = require 'harpoon.ui'
    vim.keymap.set('n', '<leader>f', mark.add_file, { desc = 'Add file to harpoon' })
    vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu)
    vim.keymap.set('n', '<C-H>', function()
      ui.nav_file(1)
    end)
    vim.keymap.set('n', '<C-J>', function()
      ui.nav_file(2)
    end)
    vim.keymap.set('n', '<C-K>', function()
      ui.nav_file(3)
    end)
    vim.keymap.set('n', '<C-L>', function()
      ui.nav_file(4)
    end)
    vim.keymap.set('n', '<C-:>', function()
      ui.nav_file(5)
    end)
  end,
}
