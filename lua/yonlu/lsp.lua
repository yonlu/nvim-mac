local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.opt.completeopt = {"menu", "menuone", "noselect"}  

-- Setup nvim-cmp.
local cmp = require("cmp")
local source_mapping = {
	buffer = "[Buffer]",
	nvim_lsp = "[LSP]",
	nvim_lua = "[Lua]",
	cmp_tabnine = "[TN]",
	path = "[Path]",
}
local lspkind = require("lspkind")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
			require("luasnip").filetype_extend("javascript", { "javascriptreact" })
		end,
	},
	mapping = {
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item()),
		["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item()),
	},

	formatting = {
		format = function(entry, vim_item)
			vim_item.kind = lspkind.presets.default[vim_item.kind]
			local menu = source_mapping[entry.source.name]
			if entry.source.name == "cmp_tabnine" then
				if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
					menu = entry.completion_item.data.detail .. " " .. menu
				end
				vim_item.kind = ""
			end
			vim_item.menu = menu
			return vim_item
		end,
	},

	sources = {
		-- tabnine completion? yayaya
		{ name = "cmp_tabnine" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
	},
})

local tabnine = require("cmp_tabnine.config")
tabnine:setup({
	max_lines = 1000,
	max_num_results = 20,
	sort = true,
	run_on_every_keystroke = true,
	snippet_placeholder = "..",
})

--local function config(_config)
--	return vim.tbl_deep_extend("force", {
--		capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
--		on_attach = function()
--			Nnoremap("gd", ":lua vim.lsp.buf.definition()<CR>")
--			Nnoremap("K", ":lua vim.lsp.buf.hover()<CR>")
--			Nnoremap("<leader>vws", ":lua vim.lsp.buf.workspace_symbol()<CR>")
--			Nnoremap("<leader>vd", ":lua vim.diagnostic.open_float()<CR>")
--			Nnoremap("[d", ":lua vim.lsp.diagnostic.goto_next()<CR>")
--			Nnoremap("]d", ":lua vim.lsp.diagnostic.goto_prev()<CR>")
--			Nnoremap("<leader>vca", ":lua vim.lsp.buf.code_action()<CR>")
--			Nnoremap("<leader>vrr", ":lua vim.lsp.buf.references()<CR>")
--			Nnoremap("<leader>vrn", ":lua vim.lsp.buf.rename()<CR>")
--			Inoremap("<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
--		end,
--	}, _config or {})
--end

--require("lspconfig").tsserver.setup(config())
require("lspconfig").tsserver.setup{
    capabilities = capabilities,
    on_attach = function()
    vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", {buffer=0})
    vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, {buffer=0})
    vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, {buffer=0})
    vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", {buffer=0})
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {buffer=0})
    end,
}

