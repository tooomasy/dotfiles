return {
	"nvim-telescope/telescope-project.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("telescope").load_extension("project")

		vim.keymap.set(
			"n",
			"<M-P>",
			":lua require'telescope'.extensions.project.project{}<CR>",
			{ noremap = true, silent = true }
		)
	end,
}
