return {{
    "nvim-treesitter/nvim-treesitter",
    event = {"BufReadPre", "BufNewFile"},
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
        ensure_installed = {"bash", "html", "javascript", "json", "lua", "markdown", "markdown_inline", "python",
                            "regex", "rust", "tsx", "typescript", "vim", "yaml", "zig"},
        highlight = {
            enable = true,
            disable = {"python"} -- Disabled due to parser issues
        },
        indent = {
            enable = true
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<C-space>",
                node_incremental = "<C-space>",
                scope_incremental = false,
                node_decremental = "<bs>"
            }
        }
    }
}, {
    "windwp/nvim-ts-autotag",
    event = {"BufReadPre", "BufNewFile"},
    opts = {}
}}
