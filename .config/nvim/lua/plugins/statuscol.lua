return {
	"luukvbaal/statuscol.nvim",
	config = function()
		local builtin = require("statuscol.builtin")
		require("statuscol").setup({
			filetype_exclude = { "neo-tree" },
			relculright = true,
			-- segments = {
			-- 	{
			-- 		text = {
			-- 			function(args)
			-- 				local ok, res = pcall(builtin.signfunc, args)
			-- 				return ok and res or ""
			-- 			end,
			-- 		},
			-- 		click = "v:lua.ScSa",
			-- 	},
			-- 	{ text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
			-- 	{ text = { "    " } },
			-- },
			segments = {
				{ text = { "%C" }, click = "v:lua.ScFa" },
				{ text = { "%s" }, click = "v:lua.ScSa" },
				{
					text = { builtin.lnumfunc, "    " },
					condition = { true, builtin.not_empty },
					click = "v:lua.ScLa",
				},
			},
		})
	end,
}
