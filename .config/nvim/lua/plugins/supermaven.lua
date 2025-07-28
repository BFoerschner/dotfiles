return {
  "supermaven-inc/supermaven-nvim",
  event = "InsertEnter",
  cmd = {
    "SupermavenUsePro",
  },
  opts = {
    keymaps = {
      accept_suggestion = "<C-l>",
      accept_word = "<C-M-l>",
    },
    log_level = "off",
    disable_inline_completion = false,
    ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
  },
}