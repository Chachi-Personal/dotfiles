local ok, reg = pcall(require, "mason-registry")
if ok then
	reg.refresh(function()
		for _, p in ipairs({ "taplo" }) do
			local okp, pkg = pcall(reg.get_package, p)
			if okp and not pkg:is_installed() then
				pkg:install()
			end
		end
	end)
end

vim.lsp.enable("taplo")
