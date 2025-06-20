-- ~/.config/nvim/lua/plugins/harpoon.lua   -- LazyVim-style spec
return {
	'ThePrimeagen/harpoon',
	branch = 'harpoon2', -- make sure you’re on v2
	dependencies = { 'nvim-lua/plenary.nvim' },
	opts = {},     -- let Harpoon init itself
	config = function()
		local harpoon = require 'harpoon'
		local list = harpoon:list()

		--------------------------------------------------------------------------
		-- util: current title for slot i
		--------------------------------------------------------------------------
		local function fname(i)
			local item = (list.items or {})[i]
			return item and vim.fn.fnamemodify(item.value, ':~:.') or '<empty>'
		end

		--------------------------------------------------------------------------
		-- (re)bind <leader>1-5 with fresh desc
		--------------------------------------------------------------------------
		local function refresh_keys()
			for i = 1, 5 do
				local lhs = ('<leader>%d'):format(i)
				pcall(vim.keymap.del, 'n', lhs) -- blow away stale map
				vim.keymap.set('n', lhs, function()
					list:select(i)
				end, { desc = ('Harpoon %d → %s'):format(i, fname(i)), noremap = true, silent = true })
			end
		end
		refresh_keys()

		--------------------------------------------------------------------------
		-- wrap add-file so keys update instantly
		--------------------------------------------------------------------------
		vim.keymap.set('n', '<leader>a', function()
			list:append()
			refresh_keys()
		end, { desc = 'Harpoon: add file' })

		--------------------------------------------------------------------------
		-- when the quick-menu closes, titles may have changed → refresh
		--------------------------------------------------------------------------
		vim.api.nvim_create_autocmd('BufWinLeave', {
			pattern = '*',
			callback = function(ev)
				if vim.bo[ev.buf].filetype == 'harpoon' then
					refresh_keys()
				end
			end,
		})
	end,
}
