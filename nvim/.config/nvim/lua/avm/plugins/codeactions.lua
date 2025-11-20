return {
    "rachartier/tiny-code-action.nvim",
    dependencies = {{"nvim-lua/plenary.nvim"}, {"nvim-telescope/telescope.nvim"}},
    event = "LspAttach",
    opts = {},
    config = function(_, opts)
        -- optional setup if the plugin exposes it
        local ok, tiny = pcall(require, "tiny-code-action")
        if ok and tiny.setup then
            tiny.setup(opts)
        end

        -- set buffer-local keymaps when an LSP attaches
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local bufnr = args.buf
                local map = function(mode, lhs, rhs)
                    vim.keymap.set(mode, lhs, rhs, {
                        buffer = bufnr
                    })
                end

                -- normal mode: code actions at cursor
                map("n", "<leader>ca", function()
                    require("tiny-code-action").code_action()
                end)
                -- visual mode: range code action for the selection
                map("v", "<leader>ca", function()
                    require("tiny-code-action").code_action(true)
                end)
            end
        })
    end
}
