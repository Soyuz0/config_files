return {
	'tpope/vim-fugitive',
	config = function()
		vim.keymap.set('n', '<leader>gv', vim.cmd.Git, { desc = '[G]it [V]iewer' })
	end,
}
