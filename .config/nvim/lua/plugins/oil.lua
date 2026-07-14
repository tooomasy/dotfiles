return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		default_file_explorer = false,
		view_options = { show_hidden = true },
		float = { -- Configure floating window
			padding = 2,
			max_width = 60,
			max_height = 20,
			border = "rounded",
		},
	},
	-- Optional dependencies
	dependencies = {
		{
			"echasnovski/mini.icons",
			lazy = false,
			opts = {
				mock_nvim_web_devicons = true,
			},
			config = function(_, opts)
				local icons = require("mini.icons")
				icons.setup(opts)
				icons.mock_nvim_web_devicons()
			end,
		},
	},
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
}
