-- lua/plugins/outline.lua
return {
	"hedyhli/outline.nvim",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle Outline" },
	},
	opts = {
		position = "right",
		width = 35,
		relative_width = false,
		auto_close = true, -- 離開 outline 視窗自動關閉
		auto_preview = true, -- 預覽（類似 peek）
		preview = {
			live = true, -- 即時更新
		},
		symbols = {
			icons = { -- 可關閉或用 devicons
				File = { icon = "󰈙", hl = "Identifier" },
				-- ... 其他
			},
		},
	},
}
