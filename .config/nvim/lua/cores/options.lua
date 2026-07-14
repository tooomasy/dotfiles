vim.o.termguicolors = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.o.shiftwidth = 2
vim.o.tabstop = 2

vim.opt.mouse = "a"

vim.opt.showmode = false
vim.opt.wrap = false

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"

	if vim.fn.has("wsl") == 1 then
		vim.g.clipboard = {
			name = "win32yank-wsl",
			copy = {
				["+"] = "win32yank.exe -i --crlf",
				["*"] = "win32yank.exe -i --crlf",
			},
			paste = {
				["+"] = "win32yank.exe -o --lf",
				["*"] = "win32yank.exe -o --lf",
			},
			cache_enabled = 0,
		}
	end
end)

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = "split"

vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
-- vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
vim.opt.confirm = true

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<M-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<M-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<M-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<M-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "G", "Gzz", { noremap = true }) -- Go to bottom and center

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "[E]xpand diagnostic message" })

-- gd: 保持原樣（同視窗跳轉）
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })

-- gD: 複製 VS Code 的 "Open Definition to the Side" (開在新 Pane)
vim.keymap.set("n", "gD", function()
	vim.cmd("vsplit")
	vim.lsp.buf.definition()
end, { desc = "Open Definition to the Side" })

-- -- 建立一個自動命令，確保每次換主題或啟動時都會修正背景色
-- vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
-- 	pattern = "*",
-- 	callback = function()
-- 		-- 將行號欄、標記欄、狀態欄位的背景全部設為透明/無背景（NONE）
-- 		vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
-- 		vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
-- 		vim.api.nvim_set_hl(0, "StatusColumn", { bg = "NONE" })
--
-- 		-- 如果你是使用 neo-tree，也可以強制修正其左側欄位高亮
-- 		vim.api.nvim_set_hl(0, "NeoTreeSignColumn", { bg = "NONE" })
-- 	end,
-- })

-- vim.opt.statuscolumn = "    "
-- vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
-- 	callback = function()
-- 		local separator = " ▎     "
-- 		vim.opt.statuscolumn = '%s%=%#LineNr4#%{(v:relnum >= 4)?v:relnum."'
-- 			.. separator
-- 			.. '":""}'
-- 			.. '%#LineNr3#%{(v:relnum == 3)?v:relnum."'
-- 			.. separator
-- 			.. '":""}'
-- 			.. '%#LineNr2#%{(v:relnum == 2)?v:relnum."'
-- 			.. separator
-- 			.. '":""}'
-- 			.. '%#LineNr1#%{(v:relnum == 1)?v:relnum."'
-- 			.. separator
-- 			.. '":""}'
-- 			.. '%#LineNr0#%{(v:relnum == 0)?v:lnum." '
-- 			.. separator
-- 			.. '":""}'
--
-- 		vim.cmd("highlight LineNr0 guifg=#dedede")
-- 		vim.cmd("highlight LineNr1 guifg=#bdbdbd")
-- 		vim.cmd("highlight LineNr2 guifg=#9c9c9c")
-- 		vim.cmd("highlight LineNr3 guifg=#7b7b7b")
-- 		vim.cmd("highlight LineNr4 guifg=#5a5a5a")
-- 	end,
-- })
