return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {"nvim-tree/nvim-web-devicons", "catppuccin/nvim"},
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status")

        -- Custom component to show macro recording
        local function macro_recording()
            local recording_register = vim.fn.reg_recording()
            if recording_register == "" then
                return ""
            else
                return "Recording @" .. recording_register
            end
        end

        -- Custom component to show search count
        local function search_count()
            if vim.v.hlsearch == 0 then
                return ""
            end
            local ok, result = pcall(vim.fn.searchcount, {
                maxcount = 999,
                timeout = 500
            })
            if not ok or next(result) == nil then
                return ""
            end
            local denominator = math.min(result.total, result.maxcount)
            return string.format("[%d/%d]", result.current, denominator)
        end

        lualine.setup({
            options = {
                theme = "catppuccin",
                globalstatus = true,
                disabled_filetypes = {
                    statusline = {"dashboard", "alpha", "starter"},
                    winbar = {}
                },
                component_separators = {
                    left = "",
                    right = ""
                },
                section_separators = {
                    left = "",
                    right = ""
                }
            },
            sections = {
                lualine_a = {{
                    "mode",
                    icon = ""
                }},
                lualine_b = {{
                    "branch",
                    icon = ""
                }, {
                    "diff",
                    symbols = {
                        added = " ",
                        modified = " ",
                        removed = " "
                    },
                    colored = true
                }, {
                    "diagnostics",
                    sources = {"nvim_diagnostic"},
                    symbols = {
                        error = " ",
                        warn = " ",
                        info = " ",
                        hint = "󰌵 "
                    },
                    colored = true
                }},
                lualine_c = {{
                    "filename",
                    file_status = true,
                    newfile_status = true,
                    path = 1, -- Relative path
                    symbols = {
                        modified = "●",
                        readonly = "",
                        unnamed = "[No Name]",
                        newfile = "[New]"
                    }
                }, {
                    search_count,
                    type = "lua_expr"
                }},
                lualine_x = {{
                    macro_recording,
                    color = {
                        fg = "#ff9e64"
                    }
                }, {
                    lazy_status.updates,
                    cond = lazy_status.has_updates,
                    color = {
                        fg = "#ff9e64"
                    }
                }, {
                    function()
                        local clients = vim.lsp.get_clients({
                            bufnr = 0
                        })
                        if #clients == 0 then
                            return ""
                        end
                        local names = {}
                        for _, client in ipairs(clients) do
                            table.insert(names, client.name)
                        end
                        return " " .. table.concat(names, ", ")
                    end,
                    color = {
                        fg = "#7aa2f7"
                    }
                }, {
                    "encoding",
                    show_bomb = true
                }, {
                    "fileformat",
                    symbols = {
                        unix = "",
                        dos = "",
                        mac = ""
                    }
                }, {
                    "filetype",
                    icon_only = false
                }},
                lualine_y = {{
                    "progress",
                    padding = {
                        left = 1,
                        right = 1
                    }
                }},
                lualine_z = {{
                    "location",
                    icon = ""
                }}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {{
                    "filename",
                    path = 1
                }},
                lualine_x = {"location"},
                lualine_y = {},
                lualine_z = {}
            },
            extensions = {"neo-tree", "lazy", "trouble", "quickfix", "fugitive"}
        })
    end
}
