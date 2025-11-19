-- Native diagnostics configuration
vim.diagnostic.config({
    virtual_text = {
        spacing = 2,
        prefix = "●",
        severity_sort = true
    },
    underline = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " "
        }
    },
    update_in_insert = false,
    float = {
        border = "rounded",
        source = "always"
    }
})
