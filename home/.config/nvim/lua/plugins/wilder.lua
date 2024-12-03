return {
	"gelguy/wilder.nvim",
	dependencies = {
		"roxma/nvim-yarp",
	},
	config = function()
		local wilder = require("wilder")
		wilder.setup({ modes = { ":" } })

		wilder.set_option("pipeline", {
			wilder.branch(wilder.cmdline_pipeline(), wilder.search_pipeline()),
		})

		wilder.set_option(
			"renderer",
			wilder.popupmenu_renderer({
				pumblend = 20,
			})
		)
	end,
}
