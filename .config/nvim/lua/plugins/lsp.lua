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
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			ts.setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			ts.install({
				"c",
				"cpp",
				"cmake",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"json",
				"markdown",
				"markdown_inline",
			})

			local group = vim.api.nvim_create_augroup("yin-treesitter", {
				clear = true,
			})

			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				callback = function(args)
					local filetype = vim.bo[args.buf].filetype
					local lang = vim.treesitter.language.get_lang(filetype)

					if not lang then
						return
					end

					local ok = pcall(vim.treesitter.start, args.buf, lang)

					if ok then
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},

	-- 2. Mason
	{
		"williamboman/mason.nvim",
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"clangd",
					"stylua",
				},
				auto_update = false,
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

			-- Filetype-based LSP enablement
			local lsp_filetypes = {
				clangd = { "c", "cpp", "objc", "objcpp", "cuda" },
				tsc = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
			}

			-- Configure LSP servers with filetype detection
			vim.lsp.config("clangd", {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
				},
				filetypes = lsp_filetypes.clangd,
				root_markers = {
					".clangd",
					".clang-tidy",
					".clang-format",
					"compile_commands.json",
					"compile_flags.txt",
					"CMakePresets.json",
					".git",
				},
				capabilities = capabilities,
			})

			vim.lsp.config("tsc", {
				filetypes = lsp_filetypes.ts_ls,
				root_markers = { "tsconfig.json", "package.json", ".git" },
				capabilities = capabilities,
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
						completion = { callSnippet = "Replace" },
					},
				},
				capabilities = capabilities,
			})

			vim.lsp.config("pyright", {
				before_init = function(_, config)
					local venv_python = config.root_dir .. "/.venv/bin/python"
					if vim.fn.executable(venv_python) == 1 then
						config.settings.python.pythonPath = venv_python
					end
				end,
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
						},
					},
				},
				capabilities = capabilities,
			})

			vim.lsp.config("rust_analyzer", {
				settings = {
					["rust-analyzer"] = { check = { command = "clippy" } },
				},
				capabilities = capabilities,
			})

			-- Enable LSP servers only for their filetypes
			local group = vim.api.nvim_create_augroup("yin-lsp-enable", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				callback = function(event)
					local filetype = vim.bo[event.buf].filetype
					for server, filetypes in pairs(lsp_filetypes) do
						if vim.list_contains(filetypes, filetype) then
							vim.lsp.enable(server)
						end
					end
				end,
			})

			-- LSP Attach
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("yin-lsp-attach", { clear = true }),
				callback = function(event)
					local bufnr = event.buf
					local client = vim.lsp.get_client_by_id(event.data.client_id)

					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "LSP: " .. desc })
					end

					map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
					map("n", "gr", function()
						require("telescope.builtin").lsp_references()
					end, "References")
					map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
					map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
					map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
					map("n", "<leader>d", vim.diagnostic.open_float, "Show Line Diagnostics")
					map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
					map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")

					if client and client:supports_method("textDocument/inlayHint") then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end
				end,
			})

			vim.diagnostic.config({
				virtual_text = {
					spacing = 2,
					source = "if_many",
				},
				signs = true,
				underline = true,
				severity_sort = true,
				update_in_insert = false,
				float = {
					border = "rounded",
					source = "if_many",
				},
			})
		end,
	},

	-- 4. Formatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		opts = {
			format_on_save = { timeout_ms = 500, lsp_format = "prefer" },
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
			},
		},
	},

	-- 5. Completion
	{
		"saghen/blink.cmp",
		version = "*",
		opts = {
			keymap = { preset = "super-tab" },
			signature = { enabled = true },
			completion = {
				list = {
					selection = {
						preselect = false,
						auto_insert = false,
					},
				},
				menu = { auto_show = true },
				documentation = { auto_show = true, auto_show_delay_ms = 200 },
				accept = {
					auto_brackets = { enabled = false },
				},
			},
			sources = {
				default = { "snippets", "lsp", "path", "buffer" },
				providers = {
					snippets = { score_offset = 10 },
					lsp = { score_offset = 5 },
					buffer = {
						score_offset = 0,
						opts = {
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end,
						},
					},
				},
			},
			snippets = {
				preset = "default",
			},
		},
	},
}
