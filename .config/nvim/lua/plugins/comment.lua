return {
	"numToStr/Comment.nvim",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		padding = true,
		sticky = true,
		ignore = "^$",
		toggler = {
			line = "<C-/>",
			block = "gbc",
		},
		opleader = {
			line = "<C-/>",
			block = "gb",
		},
	},
	config = function(_, opts)
		require("Comment").setup(opts)

		-- 支援終端常見的 Ctrl + / → <C-_> 轉發
		vim.keymap.set("n", "<C-/>", "gcc", { remap = true, silent = true })
		vim.keymap.set("n", "<C-_>", "gcc", { remap = true, silent = true })
		vim.keymap.set("x", "<C-/>", "gc", { remap = true, silent = true })
		vim.keymap.set("x", "<C-_>", "gc", { remap = true, silent = true })
	end,
}
