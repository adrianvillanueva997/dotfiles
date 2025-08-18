return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    local toggleterm = require("toggleterm")

    toggleterm.setup({
      size = 20,
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 3,
      },
    })

    -- Create a dedicated floating terminal
    local Terminal = require("toggleterm.terminal").Terminal
    local float_term = Terminal:new({ direction = "float", hidden = true })

    function _FLOAT_TERM_TOGGLE()
      float_term:toggle()
    end

    -- Keymap: <leader>tt
    vim.api.nvim_set_keymap(
      "n",
      "<leader>tt",
      "<cmd>lua _FLOAT_TERM_TOGGLE()<CR>",
      { noremap = true, silent = true }
    )
  end,
}
