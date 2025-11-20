return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim"},
    keys = {{
        "<leader>e",
        "<cmd>Neotree toggle<cr>",
        desc = "Explorer NeoTree (Root Dir)"
    }},
    opts = {
        filesystem = {
            follow_current_file = {
                enabled = true
            },
            filtered_items = {
                visible = true,
                hide_dotfiles = false,
                hide_gitignored = false
            }
        }
    }
}
