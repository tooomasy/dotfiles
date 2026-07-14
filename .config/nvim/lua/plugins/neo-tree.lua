local neotree_width = 40

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- "nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	---@module "neo-tree"
	---@type neotree.Config?
	opts = {
		enable_git_status = false,
		default_component_configs = {
			indent = {
				padding = 4,
			},
		},
		filesystem = {
			filtered_items = {
				visible = false,
				hide_dotfiles = false,
				hide_gitignored = false,
				hide_hidden = false,
			},
			follow_current_file = {
				enabled = true,
				leave_dirs_open = true,
			},
			use_libuv_file_watcher = true,

			commands = {
				open_oil = function(state)
					local node = state.tree:get_node()
					local path = node:get_id()
					if node.type == "file" then
						path = vim.fn.fnamemodify(path, ":h")
					end
					vim.cmd("Oil --float " .. path)
				end,
			},
			window = {
				position = "left",
				width = neotree_width,
				mappings = {
					["i"] = "open_oil",
					["<cr>"] = "open",
				},
			},
		},
		event_handlers = {
			{
				event = "neo_tree_buffer_enter",
				handler = function()
					vim.opt_local.number = false
					vim.opt_local.relativenumber = false
					vim.opt_local.signcolumn = "no"
					vim.opt_local.statuscolumn = ""
				end,
			},
			{
				event = "file_opened",
				handler = function(file_path)
					vim.defer_fn(function()
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							if vim.api.nvim_win_is_valid(win) then
								local buf = vim.api.nvim_win_get_buf(win)
								if vim.bo[buf].filetype == "neo-tree" then
									vim.api.nvim_win_set_width(win, neotree_width)
								end
							end
						end
					end, 10)
				end,
			},
		},
	},
}
