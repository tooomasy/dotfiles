return {
	"numToStr/Comment.nvim",
	opts = {
		-- Add any custom configurations here if needed
	},
	config = function()
		local ft = require("Comment.ft")
		ft.set("cpp", { "//%s", "/*%s*/" })

		vim.keymap.set("n", "<C-_>", "gcc", { remap = true, desc = "Toggle comment line" })
		vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment line" })
		vim.keymap.set("v", "<C-_>", "gc", { remap = true, desc = "Toggle comment selection" })
		vim.keymap.set("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment selection" })
	end,
}
