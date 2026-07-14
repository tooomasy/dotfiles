return {
	"stevearc/aerial.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {},
	config = function()
		require("aerial").setup({
			backends = { "lsp", "treesitter", "markdown", "man" },

			attach_mode = "global",

			-- 設定佈局
			layout = {
				max_width = { 47, 0.2 },
				min_width = 47,
				default_direction = "right", -- 預設顯示在右側
			},

			highlight_on_hover = true,

			close_on_select = false,
		})

		vim.keymap.set("n", "<leader>t", "<cmd>AerialToggle!<CR>", { desc = "Toggle Code Outline" })
	end,
}
