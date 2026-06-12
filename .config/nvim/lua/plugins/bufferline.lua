return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		vim.opt.termguicolors = true
		require("bufferline").setup({
			options = {
				mode = "buffers",
				diagnostics = "nvim_lsp", -- 顯示 LSP 錯誤提示 (像 VS Code 一樣)
				offsets = { -- 這段能讓標籤頁與左側檔案樹對齊
					{ filetype = "neo-tree", text = "File Explorer", text_align = "left", separator = true },
				},
				separator_style = "slant", -- "slant", "thick", "thin" 都可以選

				--- 關鍵：過濾掉沒有名字的空白標籤頁 [No Name] ---
				custom_filter = function(buf_number, buf_numbers)
					-- 獲取該 buffer 的檔名
					local buf_name = vim.api.nvim_buf_get_name(buf_number)

					-- 獲取該 buffer 的類型 (filetype) 和緩衝區類型 (buftype)
					local buf_ft = vim.bo[buf_number].filetype
					local buf_bt = vim.bo[buf_number].buftype

					-- 如果檔名、buftype、filetype 全都為空，代表是剛開啟的 [No Name] 緩衝區，則返回 false 將其隱藏
					if buf_name == "" and buf_bt == "" and buf_ft == "" then
						return false
					end

					-- 其他正常的檔案與緩衝區則返回 true 正常顯示
					return true
				end,
			},
		})
	end,
}
