return {
	"nvim-lualine/lualine.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"linrongbin16/lsp-progress.nvim",
	},
	config = function()
		require("lsp-progress").setup({
			client_format = function(client_name, spinner, series_messages)
				if #series_messages == 0 then
					return client_name
				end

				return (client_name .. " (" .. spinner .. " " .. table.concat(series_messages, ", ")) .. ")"
			end,
			format = function(client_messages)
				if #client_messages == 0 then
					return ""
				end

				return table.concat(client_messages, " ")
			end,
		})
		require("lualine").setup({
			options = {
				icons_enabled = true,
				disabled_filetypes = {
					"neo-tree",
					"terminal",
					"lazygit",
					"DiffviewFiles",
					"alpha",
					""
				},
				component_separators = "|",
				section_separators = {
					left = "",
					right = ""
				},
			},
			sections = {
				lualine_a = {
					{
						"mode",
						right_padding = 2,
						separator = {
							left = "",
						},
					}
				},
				lualine_b = {
					{
						"filename",
						path = 1,
						shorting_target = 50,
					},
					"branch"
				},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {
					{
						function()
							return require("lsp-progress").progress()
						end,
						cond = function()
							local filetype = vim.api.nvim_buf_get_option(0, "filetype")
							local clients = vim.lsp.get_active_clients()
							if next(clients) == nil then
								return false
							end

							for _, client in ipairs(clients) do
								local filetypes = client.config.filetypes
								if filetypes and vim.fn.index(filetypes, filetype) ~= -1 then
									return true
								end
							end

							return false
						end,
					},
					{
						function()
							return "No LSP"
						end,
						cond = function()
							local filetype = vim.api.nvim_buf_get_option(0, "filetype")
							local clients = vim.lsp.get_active_clients()
							if next(clients) == nil then
								return true
							end

							for _, client in ipairs(clients) do
								local filetypes = client.config.filetypes
								if filetypes and vim.fn.index(filetypes, filetype) ~= -1 then
									return false
								end
							end

							return true
						end,
						color = {
							fg = "#ea6c6d",
							gui = "bold",
						},
					},
					{
						"diagnostics",
						sources = { "nvim_lsp" },
						sections = { "error", "warn", "info", "hint" },
						colored = true,
						update_in_insert = true,
					},
					"filetype",
					{
						require("lazy.status").updates,
						cond = require("lazy.status").has_updates,
					}
				},
				lualine_z = {
					{
						"location",
						left_padding = 2,
						separator = {
							right = "",
						},
					}
				}
			},
			inactive_sections = {},
			tabline = {},
			extensions = {}
		})
	end
}
