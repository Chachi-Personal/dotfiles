local ok, reg = pcall(require, "mason-registry")
if not ok then
	return
end
reg.refresh(function()
	for _, p in ipairs({ "lua-language-server" }) do
		local okp, pkg = pcall(reg.get_package, p)
		if okp and not pkg:is_installed() then
			pkg:install()
		end
	end
end)

vim.lsp.enable("lua_ls")
