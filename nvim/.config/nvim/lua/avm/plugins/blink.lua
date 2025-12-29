return { -- blink.cmp
{
    "saghen/blink.cmp",
    lazy = false,
    dependencies = {"rafamadriz/friendly-snippets", "onsails/lspkind.nvim"},
    build = "cargo build --release",
    opts = {
        keymap = {
            ["<C-space>"] = {"show", "show_documentation", "hide_documentation"},
            ["<C-e>"] = {"hide"},
            ["<C-y>"] = {"select_and_accept"},
            ["<CR>"] = {"select_and_accept", "fallback"},
            ["<Up>"] = {"select_prev", "fallback"},
            ["<Down>"] = {"select_next", "fallback"},
            ["<C-p>"] = {"select_prev", "fallback"},
            ["<C-n>"] = {"select_next", "fallback"},
            ["<C-b>"] = {"scroll_documentation_up", "fallback"},
            ["<C-f>"] = {"scroll_documentation_down", "fallback"},
            ["<Tab>"] = {"snippet_forward", "fallback"},
            ["<S-Tab>"] = {"snippet_backward", "fallback"}
        },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = "mono"
        },
        sources = {
            default = {"lsp", "path", "snippets", "buffer"}
        },
        completion = {
            trigger = {
                show_on_insert_on_trigger_character = true
            },
            menu = {
                border = "rounded",
                winblend = 0,
                winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
                draw = {
                    padding = 1,
                    gap = 1,
                    columns = {{"kind_icon"}, {
                        "label",
                        gap = 1
                    }, {
                        "kind",
                        gap = 1
                    }},
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local lspkind = require("lspkind")
                                local icon = lspkind.symbolic(ctx.kind, {
                                    mode = "symbol"
                                })
                                return icon
                            end,
                            highlight = function(ctx)
                                return "CmpItemKind" .. ctx.kind
                            end
                        },
                        kind = {
                            text = function(ctx)
                                return ctx.kind
                            end,
                            highlight = function(ctx)
                                return "CmpItemKind" .. ctx.kind
                            end
                        },
                        label = {
                            width = {
                                fill = true,
                                max = 60
                            },
                            text = function(ctx)
                                return ctx.label .. (ctx.label_detail or "")
                            end,
                            highlight = function(ctx)
                                return ctx.deprecated and "CmpItemAbbrDeprecated" or "CmpItemAbbr"
                            end
                        }
                    }
                }
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 100,
                window = {
                    border = "rounded",
                    winblend = 0,
                    winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
                    max_width = 80,
                    max_height = 20
                }
            }
        },
        signature = {
            enabled = false -- Disabled to avoid duplication with documentation
        },
        fuzzy = {
            prebuilt_binaries = {
                download = true,
                force_version = nil
            }
        }
    }
}, -- lspkind for better icons
{
    "onsails/lspkind.nvim",
    lazy = true,
    opts = {
        mode = "symbol",
        symbol_map = {
            Text = "󰉿",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰜢",
            Variable = "󰀫",
            Class = "󰠱",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "󰑭",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏆",
            File = "󰈙",
            Reference = "󰈇",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "󰙅",
            Event = "",
            Operator = "󰆕",
            TypeParameter = ""
        }
    }
}, -- LSP file operations (rename/move files with LSP)
{
    "antosha417/nvim-lsp-file-operations",
    event = {"BufReadPre", "BufNewFile"},
    config = true
}, -- Lazydev for Lua dev
{
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
        library = {{
            path = "${3rd}/plenary.nvim/lua",
            words = {"plenary"}
        }}
    }
}}
