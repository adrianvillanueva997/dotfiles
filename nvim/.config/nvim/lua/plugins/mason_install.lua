return {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "biome",
                "lua-language-server",
                "pyright",
                "ruff",
                "ty",
                "stylua",
                "gopls",
                "tsp-server",
                "terraform-ls",
                "rust-analyzer",
                "dockerfile-language-server",
                "tfsec",
                "tflint"
            },
        },
    },
}
