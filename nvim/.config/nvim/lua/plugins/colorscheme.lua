return {
    "marko-cerovac/material.nvim",
    name = "colorscheme material",
    priority = 1000,
    material_style = "darker",
    config = function()
        vim.g.material_style = "darker"
        require("material").setup()
        vim.cmd("colorscheme material")
    end,
}
