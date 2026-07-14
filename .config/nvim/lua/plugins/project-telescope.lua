return {
	"nvim-telescope/telescope-project.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("telescope").load_extension("project")

		vim.keymap.set("n", "<M-P>", function()
			require("telescope").extensions.project.project({})
		end, { noremap = true, silent = true, desc = "Telescope Projects" })
	end,
}
