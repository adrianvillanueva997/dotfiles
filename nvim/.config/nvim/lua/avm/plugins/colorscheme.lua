return {{
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    name = "catppuccin",
    opts = {
        flavour = "mocha",
        background = {
            light = "latte",
            dark = "mocha"
        },
        transparent_background = false,
        show_end_of_line = true,
        lsp_styles = {
            virtual_text = {
                errors = {"italic"},
                hints = {"italic"},
                warnings = {"italic"},
                information = {"italic"},
                ok = {"italic"}
            },
            underlines = {
                errors = {"underline"},
                hints = {"underline"},
                warnings = {"underline"},
                information = {"underline"},
                ok = {"underline"}
            },
            inlay_hints = {
                background = true
            }
        },
        integrations = {
            alpha = true,
            cmp = true,
            gitsigns = true,
            illuminate = true,
            indent_blankline = {
                enabled = true,
                colored_indent_levels = true
            },
            lsp_trouble = true,
            mason = true,
            mini = {
                enabled = true
            },
            native_lsp = {
                enabled = true,
                underlines = {
                    errors = {"undercurl"},
                    hints = {"undercurl"},
                    warnings = {"undercurl"},
                    information = {"undercurl"}
                }
            },
            navic = {
                enabled = true,
                custom_bg = "lualine"
            },
            neotest = true,
            noice = true,
            notify = true,
            neotree = true,
            semantic_tokens = true,
            telescope = true,
            treesitter = true,
            which_key = true
        }
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 999,
        name = "kanagawa",
        opts = {
            compile = false,
            undercurl = true,
            commentStyle = {
                italic = true
            },
            functionStyle = {
                bold = true
            },
            keywordStyle = {
                italic = true
            },
            statementStyle = {
                bold = true
            },
            typeStyle = {
                italic = true
            },
            transparent = false,
            dimInactive = true,
            theme = "dragon",
            background = {
                dark = "dragon",
                light = "lotus"
            },
            overrides = function(colors)
                return {
                    -- Keywords, types, sections, tags, constants - italic
                    Keyword = {
                        italic = true
                    },
                    Type = {
                        italic = true
                    },
                    Tag = {
                        italic = true
                    },
                    Constant = {
                        italic = true
                    },

                    -- Functions, methods, classes - bold
                    Function = {
                        bold = true
                    },
                    Method = {
                        bold = true
                    },
                    ["@class"] = {
                        bold = true
                    },

                    -- Comments - italic + underline
                    Comment = {
                        italic = true,
                        underline = true
                    },

                    -- Deprecated - bold + strikethrough
                    Deprecated = {
                        bold = true,
                        strikethrough = true
                    }
                }
            end
        }
    }
}}
