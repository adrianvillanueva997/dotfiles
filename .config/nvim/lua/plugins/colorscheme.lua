return {
    "marko-cerovac/material.nvim",
    name = "colorscheme material",
    priority = 1000,
    material_style = "darker",

    config = function()
        require("material").setup()
        vim.g.material_style = "darker"
        vim.cmd("colorscheme material")
    end
}
