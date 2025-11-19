return {{
    "nvim-treesitter/nvim-treesitter",
    cmd = {"TSUpdate", "TSInstall", "TSLog", "TSUninstall"},
    opts_extend = {"ensure_installed"},
    build = ":TSUpdate",
    branch = "main",
    config = function()
        -- import nvim-treesitter plugin
        local treesitter = require("nvim-treesitter.configs")
        -- configure treesitter
        treesitter.setup({ -- enable syntax highlighting
            highlight = {
                enable = true
                -- disable = { "python" },
            },
            folds = {
                enable = true
            },
            -- enable indentation
            indent = {
                enable = true
            },
            -- ensure these languages parsers are installed
            ensure_installed = {"bash", "html", "javascript", "json", "lua", "markdown", "markdown_inline", "python",
                                "regex", "tsx", "typescript", "vim", "yaml", "python", "zig"},
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false
                }
            },
            additional_vim_regex_highlighting = false
        })
    end
}, -- NOTE: js,ts,jsx,tsx Auto Close Tags
{
    "windwp/nvim-ts-autotag",
    enabled = true,
    ft = {"html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte"},
    config = function()
        -- Independent nvim-ts-autotag setup
        require("nvim-ts-autotag").setup({
            opts = {
                enable_close = true, -- Auto-close tags
                enable_rename = true, -- Auto-rename pairs
                enable_close_on_slash = false -- Disable auto-close on trailing `</`
            },
            per_filetype = {
                ["html"] = {
                    enable_close = true -- Disable auto-closing for HTML
                },
                ["typescriptreact"] = {
                    enable_close = true -- Explicitly enable auto-closing (optional, defaults to `true`)
                }
            }
        })
    end
}}
