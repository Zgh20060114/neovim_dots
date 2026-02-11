return{
  "HiPhish/rainbow-delimiters.nvim",
  enabled = false,
  config = function()
    local rainbow = require("rainbow-delimiters")
    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow.strategy["local"],
      },
      query = {
        [""] = "rainbow-delimiters",
        tsx = "rainbow-parens",
      },
    }
  end,
}
