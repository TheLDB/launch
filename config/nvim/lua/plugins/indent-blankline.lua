return {
	"lukas-reineke/indent-blankline.nvim",
	event = "BufRead",
	config = function()
		require("indent_blankline").setup {
			char = "▏",
			buftype_exclude = { "terminal" },
			show_current_context = true,
		}
	end,
}
