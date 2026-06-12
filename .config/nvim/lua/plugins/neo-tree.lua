return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	lazy = false, -- neo-tree will lazily load itself
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
				visible = false, -- when true, they will just be displayed differently than normal items
				hide_dotfiles = false,
				hide_gitignored = false,
				hide_hidden = false,
			},
			follow_current_file = {
				enabled = true, -- This will find and focus the file in the active buffer every time
				leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
			},
			use_libuv_file_watcher = true,

			commands = {
				-- Custom command to open oil.nvim in a floating window
				open_oil = function(state)
					local node = state.tree:get_node()
					local path = node:get_id() -- Get the current node's path
					if node.type == "file" then
						path = vim.fn.fnamemodify(path, ":h") -- Use parent directory for files
					end
					vim.cmd("Oil --float " .. path)
				end,
			},
			window = {
				mappings = {
					["i"] = "open_oil", -- Map 'i' in Neo-tree to open oil.nvim in float
				},
			},
		},
	},
}
