return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	keys = {
		{
			"<C-p>",
			function()
				require("telescope.builtin").find_files()
			end,
			desc = "Search Files",
		},
		{
			"<leader><leader>",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Find existing buffers",
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
	},
	config = function()
		local telescope = require("telescope")
		local telescopeConfig = require("telescope.config")

		local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
		table.insert(vimgrep_arguments, "--hidden")
		table.insert(vimgrep_arguments, "--glob")
		table.insert(vimgrep_arguments, "!**/.git/*")

		telescope.setup({
			defaults = {
				vimgrep_arguments = vimgrep_arguments,
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
			pickers = {
				find_files = {
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				},
				buffers = {
					initial_mode = "normal",
					mappings = {
						n = {
							["dd"] = require("telescope.actions").delete_buffer,
						},
					},
				},
			},
		})

		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files" })
		vim.keymap.set(
			"n",
			"gr",
			require("telescope.builtin").lsp_references,
			{ desc = "LSP Go to References (VS Code style)" }
		)

		vim.keymap.set("n", "<leader>b", function()
			local has_bufferline, bufferline = pcall(require, "bufferline")
			local bufs = {}
			if has_bufferline then
				local elements = bufferline.get_elements().elements
				for _, el in ipairs(elements) do
					table.insert(bufs, el.id)
				end
			else
				bufs = vim.api.nvim_list_bufs()
			end
			local buf_order = {}
			for index, buf_id in ipairs(bufs) do
				buf_order[buf_id] = index
			end
			local current_buf = vim.api.nvim_get_current_buf()

			require("telescope.builtin").buffers({
				initial_mode = "insert",
				show_all_buffers = false,
				sort_mru = false,
				sort_buffers = false,
				tiebreak = function(current_entry, existing_entry, _)
					local order_a = buf_order[current_entry.bufnr] or 999
					local order_b = buf_order[existing_entry.bufnr] or 999
					return order_a < order_b
				end,
				on_complete = {
					function(picker)
						local finder = picker.finder
						for i, entry in ipairs(finder.results) do
							if entry.bufnr == current_buf then
								picker:set_selection(i)
								break
							end
						end
					end,
				},
			})
		end, { desc = "Change the focus buffers" })
	end,
}
