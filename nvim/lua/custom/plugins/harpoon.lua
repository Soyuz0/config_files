return {
	'ThePrimeagen/harpoon',
	config = function()
		local mark = require 'harpoon.mark'
		local ui = require 'harpoon.ui'
		vim.keymap.set('n', '<leader>f', mark.add_file, { desc = 'Add file to harpoon' })
		vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu)

		local function setup_harpoon_keys()
			local ok, harpoon = pcall(require, 'harpoon')
			if not ok then
				return
			end
			if harpoon.list and not harpoon._current then
				harpoon:setup {}
			end

			local function fname(i)
				if harpoon.list then
					local item = (harpoon:list().items or {})[i]
					return item and vim.fn.fnamemodify(item.value, ':~:.') or '<empty>'
				end
				local ok_mark, mark = pcall(require, 'harpoon.mark')
				if ok_mark and mark.get_marked_file_name then
					local p = mark.get_marked_file_name(i)
					return p ~= '' and vim.fn.fnamemodify(p, ':~:.') or '<empty>'
				end
				return '<empty>'
			end

			for i = 1, 5 do
				local lhs = ('<leader>%d'):format(i)

				-- explicitly delete old mapping first
				pcall(vim.keymap.del, 'n', lhs)

				-- rebind with updated description
				vim.keymap.set('n', lhs, function()
					if harpoon.list then
						harpoon:list():select(i)
					else
						require('harpoon.ui').nav_file(i)
					end
				end, {
					desc = ('Harpoon %d → %s'):format(i, fname(i)),
					noremap = true,
					silent = true,
				})
			end
		end

		-- First registration on startup
		setup_harpoon_keys()

		-------------------------------------------------------------------------------
		-- 4.  AUTO-REFRESH THE DESCRIPTIONS WHEN THE LIST CHANGES
		-------------------------------------------------------------------------------
		-- Harpoon v2: listen to file add/remove
		pcall(function()
			local Events = require('harpoon.extensions').event_names
			local Extensions = require 'harpoon.extensions'
			Extensions.extensions:subscribe(Events.APPEND, setup_harpoon_keys)
			Extensions.extensions:subscribe(Events.REMOVE, setup_harpoon_keys)
		end)

		-- Harpoon v1: fallback if needed
		vim.api.nvim_create_autocmd('User', {
			pattern = 'HarpoonAfterMark',
			callback = setup_harpoon_keys,
		})
		vim.keymap.set('n', '<leader>hr', setup_harpoon_keys, { desc = 'Harpoon: Refresh key descriptions' })
	end,
}
