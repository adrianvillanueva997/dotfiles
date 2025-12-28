return {
    "lewis6991/gitsigns.nvim",
    event = {"BufReadPre", "BufNewFile"},
    opts = {
        signs = {
            add = {
                text = "▍",
                numhl = "GitSignsAddNr",
                linehl = "GitSignsAddLn"
            },
            change = {
                text = "▍",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn"
            },
            delete = {
                text = "▁",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn"
            },
            topdelete = {
                text = "▔",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn"
            },
            changedelete = {
                text = "▍",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn"
            },
            untracked = {
                text = "┆",
                numhl = "GitSignsUntrackedNr"
            }
        },
        signcolumn = true,
        numhl = true,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
            interval = 1000,
            follow_files = true
        },
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol",
            delay = 200,
            ignore_whitespace = false,
            virt_text_priority = 100
        },
        current_line_blame_formatter = "  <author>, <author_time:%Y-%m-%d> - <summary>",
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]h", function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    gs.next_hunk()
                end)
                return "<Ignore>"
            end, {
                expr = true,
                desc = "Next Hunk"
            })

            map("n", "[h", function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return "<Ignore>"
            end, {
                expr = true,
                desc = "Prev Hunk"
            })

            -- Stage/Reset
            map("n", "<leader>hs", gs.stage_hunk, {
                desc = "Stage Hunk"
            })
            map("n", "<leader>hr", gs.reset_hunk, {
                desc = "Reset Hunk"
            })
            map("v", "<leader>hs", function()
                gs.stage_hunk {vim.fn.line("."), vim.fn.line("v")}
            end, {
                desc = "Stage Selected Hunk"
            })
            map("v", "<leader>hr", function()
                gs.reset_hunk {vim.fn.line("."), vim.fn.line("v")}
            end, {
                desc = "Reset Selected Hunk"
            })
            map("n", "<leader>hS", gs.stage_buffer, {
                desc = "Stage Buffer"
            })
            map("n", "<leader>hu", gs.undo_stage_hunk, {
                desc = "Undo Stage Hunk"
            })
            map("n", "<leader>hR", gs.reset_buffer, {
                desc = "Reset Buffer"
            })

            -- Preview and Blame
            map("n", "<leader>hp", gs.preview_hunk, {
                desc = "Preview Hunk"
            })
            map("n", "<leader>hb", function()
                gs.blame_line {
                    full = true
                }
            end, {
                desc = "Blame Line"
            })
            map("n", "<leader>hB", gs.blame, {
                desc = "Blame Buffer"
            })
            map("n", "<leader>tb", gs.toggle_current_line_blame, {
                desc = "Toggle Line Blame"
            })

            -- Diff
            map("n", "<leader>hd", gs.diffthis, {
                desc = "Diff This"
            })
            map("n", "<leader>hD", function()
                gs.diffthis("~")
            end, {
                desc = "Diff This ~"
            })
            map("n", "<leader>hq", gs.setqflist, {
                desc = "Quickfix Hunks"
            })
            map("n", "<leader>hQ", function()
                gs.setqflist("all")
            end, {
                desc = "Quickfix All Hunks"
            })
            map("n", "<leader>td", gs.toggle_deleted, {
                desc = "Toggle Deleted"
            })
            map("n", "<leader>tw", gs.toggle_word_diff, {
                desc = "Toggle Word Diff"
            })

            -- Text object
            map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>", {
                desc = "Select Hunk"
            })
        end
    }
}
