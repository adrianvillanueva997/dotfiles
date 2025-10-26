return { -- Catppuccin theme
{
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = { -- Configure background variants
            light = "latte",
            dark = "mocha"
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = true,
        dim_inactive = {
            enabled = false,
            shade = "dark",
            percentage = 0.15
        },
        styles = {
            comments = {"italic"},
            conditionals = {"italic"},
            loops = {},
            functions = {},
            keywords = {"bold"},
            strings = {},
            numbers = {},
            booleans = {"bold"},
            properties = {},
            types = {"bold"}
        },
        integrations = {
            treesitter = true,
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = {"italic"},
                    hints = {"italic"},
                    warnings = {"italic"},
                    information = {"italic"}
                },
                underlines = {
                    errors = {"undercurl"},
                    hints = {"undercurl"},
                    warnings = {"undercurl"},
                    information = {"undercurl"}
                }
            },
            telescope = true,
            nvimtree = true,
            which_key = true,
            cmp = true,
            gitsigns = true,
            indent_blankline = {
                enabled = true,
                colored_indent_levels = false
            }
        }
    }
}, -- Tell LazyVim to load catppuccin as the colorscheme
{
    "LazyVim/LazyVim",
    opts = {
        colorscheme = "catppuccin"
    }
}}
