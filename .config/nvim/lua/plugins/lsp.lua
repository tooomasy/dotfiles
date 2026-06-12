-- lsp.lua ── Modern Native LSP Setup (Neovim 0.11+ Optimized)

-- Emergency Utility: Pressing <Esc> in Normal mode will now also
-- force-stop any "stuck" snippet tracking to prevent Lua errors.
vim.keymap.set("n", "<Esc>", function()
	vim.cmd("noh")
	if vim.snippet then
		vim.snippet.stop()
	end
	return "<Esc>"
end, { expr = true, desc = "Clear highlights and stop snippets" })

return {
	-- 1. Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"cpp",
					"css",
					"html",
					"javascript",
					"json",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"python",
					"query",
					"rust",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
					"yaml",
				},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = { enable = true },
			})
		end,
	},

	-- 2. Mason
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"clangd",
					"ts_ls",
					"rust_analyzer",
					"stylua",
					"black",
					"prettier",
					"eslint_d",
				},
				auto_update = true,
			})
		end,
	},

	-- 3. Core LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"j-hui/fidget.nvim",
		},
		config = function()
			require("fidget").setup({})
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim" } },
							workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
							completion = { callSnippet = "Replace" },
						},
					},
				},
				-- pyright = {
				-- 	settings = {
				-- 		python = { analysis = { autoSearchPaths = true, diagnosticMode = "workspace" } },
				-- 	},
				-- },
				clangd = {
					cmd = { "clangd", "--background-index", "--clang-tidy" },
				},
				ts_ls = {},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = { check = { command = "clippy" } },
					},
				},
			}

			for name, opts in pairs(servers) do
				vim.lsp.config(name, vim.tbl_deep_extend("force", { capabilities = capabilities }, opts))
				vim.lsp.enable(name)
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("yin-lsp-attach", { clear = true }),
				callback = function(event)
					local bufnr = event.buf
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "LSP: " .. desc })
					end

					map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
					map("n", "gr", vim.lsp.buf.references, "References")
					map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
					map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
					map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")

					if client and client.supports_method("textDocument/inlayHint") then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end
				end,
			})
		end,
	},

	-- 4. Formatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		opts = {
			format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
			formatters_by_ft = {
				lua = { "stylua" },
				cpp = { "clang_format" },
				javascript = { "prettier" },
			},
		},
	},

	-- 5. Completion ── blink.cmp (FIXED SECTION)
	{
		"saghen/blink.cmp",
		version = "*", -- Ensure stable version
		opts = {
			keymap = { preset = "super-tab" },

			completion = {
				list = {
					selection = {
						preselect = false,
						-- CRITICAL FIX: Changing auto_insert to false stops the
						-- start_col/end_col error by preventing "ghost" text edits.
						auto_insert = false,
					},
				},
				menu = { auto_show = true },
				documentation = { auto_show = true, auto_show_delay_ms = 200 },
				accept = {
					-- Disable auto-brackets to avoid conflict with LSP-inserted brackets
					auto_brackets = { enabled = false },
				},
			},

			sources = {
				default = { "snippets", "lsp", "path", "buffer" },
				providers = {
					snippets = { score_offset = 10 },
					lsp = { score_offset = 5 },
				},
			},

			snippets = {
				preset = "default", -- Uses Neovim's native vim.snippet
			},
		},
	},
}
