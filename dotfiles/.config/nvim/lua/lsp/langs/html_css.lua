vim.api.nvim_create_autocmd("FileType", {
    pattern = { "html", "css", "scss", "less" },
    group = vim.api.nvim_create_augroup("Lang_HtmlCss", { clear = true }),
    once = true,
    callback = function()
        local ok, reg = pcall(require, "mason-registry")
        if ok then
            reg.refresh(function()
                for _, p in ipairs({ "html-lsp", "css-lsp", "prettier" }) do
                    local okp, pkg = pcall(reg.get_package, p)
                    if okp and not pkg:is_installed() then
                        pkg:install()
                    end
                end
            end)
        end
        vim.lsp.enable("html")
        vim.lsp.enable("cssls")
    end,
})
