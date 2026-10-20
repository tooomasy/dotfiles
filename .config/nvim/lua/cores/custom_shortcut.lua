-- Usage: :CF 1234A
vim.api.nvim_create_user_command("CF", function(opts)
	local target = opts.args
	if target == "" then
		print("Please provide a target folder name! Example: :CF 1234A")
		return
	end

	-- 1. Run your makefile 'setup' target
	vim.cmd("!make setup TARGET=" .. target)

	-- 2. Open main.cc directly in Neovim
	vim.cmd("edit " .. target .. "/main.cc")
end, { nargs = 1 })
