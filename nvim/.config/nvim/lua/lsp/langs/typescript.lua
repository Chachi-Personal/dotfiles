vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    group = vim.api.nvim_create_augroup("Lang_TS", { clear = true }),
    once = true,
    callback = function()
        local ok, reg = pcall(require, "mason-registry")
        if ok then
            reg.refresh(function()
                for _, p in ipairs({ "vtsls", "eslint-lsp", "prettier" }) do
                    local okp, pkg = pcall(reg.get_package, p)
                    if okp and not pkg:is_installed() then
                        pkg:install()
                    end
                end
            end)
        end
        vim.lsp.enable("vtsls")
        vim.lsp.enable("eslint")
    end,
})
