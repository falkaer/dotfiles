return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	lazy = true,
	event = "VeryLazy",
	cmd = "ConformInfo",
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({
					lsp_fallback = false,
					async = false,
					quiet = false,
					timeout_ms = 3000,
				})
			end,
			mode = { "n", "v" },
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			fish = { "fish_indent" },
			sh = { "shfmt" },
			python = { "isort", "black" },
			rust = { "rustfmt" },
			typst = { "typstfmt" },
		},
	},
}
