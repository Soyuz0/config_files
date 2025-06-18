return {
	{
		'CopilotC-Nvim/CopilotChat.nvim',
		dependencies = {
			{ 'github/copilot.vim' },     -- or zbirenbaum/copilot.lua
			{ 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
		},
		build = 'make tiktoken',              -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
		},
		-- See Commands section for default commands if you want to lazy load on them
		keys = {
			{ '<leader>zc', '<cmd>CopilotChat<cr>',         mode = 'n', desc = ' Copilot Chat' },
			{ '<leader>ze', '<cmd>CopilotChatExplain<cr>',  mode = 'v', desc = ' Explain Code' },
			{ '<leader>zr', '<cmd>CopilotChatReview<cr>',   mode = 'v', desc = ' Review Code' },
			{ '<leader>zf', '<cmd>CopilotChatFix<cr>',      mode = 'v', desc = ' Fix Code' },
			{ '<leader>zo', '<cmd>CopilotChatOptimize<cr>', mode = 'v', desc = ' Optimize Code' },
			{ '<leader>zd', '<cmd>CopilotChatDocs<cr>',     mode = 'v', desc = ' Add Documentation' },
			{ '<leader>zt', '<cmd>CopilotChatTests<cr>',    mode = 'v', desc = ' Generate Tests' },
		},
	},
}
