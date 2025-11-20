return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        -- Enable the modules you want
        bigfile = {
            enabled = true
        },
        dashboard = {
            enabled = true
        },
        indent = {
            enabled = true
        },
        input = {
            enabled = true
        },
        notifier = {
            enabled = false
        },
        quickfile = {
            enabled = true
        },
        scroll = {
            enabled = true
        },
        statuscolumn = {
            enabled = true
        },
        words = {
            enabled = true
        },
        lazygit = {
            enabled = true
        }
    },
    keys = {{
        "<leader>z",
        function()
            Snacks.zen()
        end,
        desc = "Toggle Zen Mode"
    }, {
        "<leader>Z",
        function()
            Snacks.zen.zoom()
        end,
        desc = "Toggle Zoom"
    }, {
        "<leader>.",
        function()
            Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer"
    }, {
        "<leader>S",
        function()
            Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer"
    }, {
        "<leader>bd",
        function()
            Snacks.bufdelete()
        end,
        desc = "Delete Buffer"
    }, {
        "<leader>cR",
        function()
            Snacks.rename.rename_file()
        end,
        desc = "Rename File"
    }, {
        "<leader>gB",
        function()
            Snacks.gitbrowse()
        end,
        desc = "Git Browse"
    }, {
        "<leader>gb",
        function()
            Snacks.git.blame_line()
        end,
        desc = "Git Blame Line"
    }, {
        "<leader>gf",
        function()
            Snacks.lazygit.log_file()
        end,
        desc = "Lazygit Current File History"
    }, {
        "<leader>gg",
        function()
            Snacks.lazygit()
        end,
        desc = "Lazygit"
    }, {
        "<leader>gl",
        function()
            Snacks.lazygit.log()
        end,
        desc = "Lazygit Log (CWD)"
    }, {
        "]]",
        function()
            Snacks.words.jump(1, true)
        end,
        desc = "Next Reference",
        mode = {"n", "t"}
    }, {
        "[[",
        function()
            Snacks.words.jump(-1, true)
        end,
        desc = "Prev Reference",
        mode = {"n", "t"}
    }},
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup some globals for debugging (optional)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for better debugging
            end
        })
    end
}
