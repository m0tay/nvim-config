vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.g.mapleader = " "

-- Keymaps
-- Copy to system clipboard
vim.keymap.set("n", "y", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "yy", '"+yy', { noremap = true, silent = true })
vim.keymap.set("v", "y", '"+y', { noremap = true, silent = true })
vim.keymap.set("x", "y", '"+y', { noremap = true, silent = true })

-- Center scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

-- File Explorer
vim.keymap.set("n", "<leader><S-e>", ":Ex<enter>")

-- Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Buffer Navigation & Utilities
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>bh", ":new<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bv", ":vnew<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>bl", ":ls<CR>", { noremap = true })
vim.keymap.set("n", "<leader>bs", ":buffer ", { noremap = true })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- Mason LSP & Tools Setup
		{ "williamboman/mason.nvim", opts = {} },
		{
			"williamboman/mason-lspconfig.nvim",
			opts = {
				config = function()
					require("mason").setup() -- Ensure mason is initialized
					require("mason-lspconfig").setup({
						ensure_installed = {
							"pyright",
							"gopls",
							"clangd",
							"solargraph",
							"kotlin_language_server",
							"crystalline",
							"jdtls",
							"elixirls",
						},
						automatic_installation = true, -- Automatically install missing LSP servers
					})
				end,
			},
		},

		-- Autocompletion
		{ "hrsh7th/nvim-cmp", opts = {} },
		{ "L3MON4D3/LuaSnip", opts = {} },

		-- Treesitter for Syntax Highlighting
		{ "nvim-treesitter/nvim-treesitter", opts = {} },
	},

	-- Colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },

	-- Automatically check for plugin updates
	checker = { enabled = true },
})

-- Optional: Basic LSP completion setup
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
})
