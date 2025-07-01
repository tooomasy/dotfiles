require("cores.options")

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		lazy = false,
		priority = 1000,
		"Mofiqul/vscode.nvim",
		config = function()
			vim.o.background = "dark"

			local c = require("vscode.colors").get_colors()
			c.vscDarkBg = "#181818"

			require("vscode").setup({
				-- Underline `@markup.link.*` variants
				underline_links = true,
				disable_nvimtree_bg = true,
				terminal_colors = true,

				color_overrides = {
					vscLineNumber = "#6e7681",
					vscPopupFront = "#cccccc",
					vscSplitDark = "#2b2b2b",

					vscBlue = "#749bd1",
					vscBlueGreen = "#82c6b1",
					vscLightBlue = "#b4dafa",
					vscAccentBlue = "#81bff9",

					vscYellow = "#dbdcaf",
					vscYellowOrange = "#f1d84a",

					vscPink = "#b78abc",
				},

				group_overrides = {
					Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
					LspInlayHint = { fg = "#969696", bg = "#262626" },
					NeoTreeNormal = { fg = "NONE", bg = c.vscDarkBg },
					NeoTreeNormalNC = { fg = "NONE", bg = c.vscDarkBg },

					RainbowDelimiterViolet = { fg = "#c578d0", bg = "NONE" },
				},
			})
			vim.cmd.colorscheme("vscode")
			vim.cmd("highlight MsgArea guibg=#181818 gui=bold guisp=NONE")
		end,
	},
	{ import = "plugins" },
})
