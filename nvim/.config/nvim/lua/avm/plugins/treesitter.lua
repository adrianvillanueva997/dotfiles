return {{
    "nvim-treesitter/nvim-treesitter",
    event = {"BufReadPre", "BufNewFile"},
    cmd = {"TSUpdate", "TSInstall", "TSLog", "TSUninstall"},
    opts_extend = {"ensure_installed"},
    build = ":TSUpdate",
    config = function()
        -- import nvim-treesitter plugin
        local treesitter = require("nvim-treesitter.configs")
        -- configure treesitter
        treesitter.setup({ -- enable syntax highlighting
            highlight = {
                enable = true,
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                    if lang == "python" then
                        return true
                    end
                end
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
                                "regex", "rust", "tsx", "typescript", "vim", "yaml", "zig"},
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
