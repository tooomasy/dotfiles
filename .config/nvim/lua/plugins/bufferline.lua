return {
	"akinsho/bufferline.nvim",
	version = "*",
	-- dependencies = "nvim-tree/nvim-web-devicons",
	dependencies = {},
	event = "VeryLazy",
	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers",
				diagnostics = "nvim_lsp", -- 顯示 LSP 錯誤提示 (像 VS Code 一樣)
				offsets = { -- 這段能讓標籤頁與左側檔案樹對齊
					{ filetype = "neo-tree", text = "File Explorer", text_align = "left", separator = true },
				},
				separator_style = "thin", -- "slant", "thick", "thin" 都可以選

				custom_filter = function(buf_number, buf_numbers)
					local buf_name = vim.api.nvim_buf_get_name(buf_number)

					local buf_ft = vim.bo[buf_number].filetype
					local buf_bt = vim.bo[buf_number].buftype

					if buf_name == "" and buf_bt == "" and buf_ft == "" then
						return false
					end
					return true
				end,
			},
		})
	end,
}
