return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = {
    ensure_installed = {
      "docker-compose-language-service",
      "tailwindcss-language-server",
      "dockerfile-language-server",
      "yaml-language-server",
      "bash-language-server",
      "lua-language-server",
      "terraform-ls",
      "json-lsp",
      "pyright",
      "gopls",
      "ruff",
      "ansiblels",
      "marksman",
      "taplo",

      "codelldb",
      "debugpy",
      "delve",

      "shellcheck",
      "hadolint",
      "markdownlint-cli2",

      "prettier",
      "black",
      "stylua",
      "shfmt",
      "goimports",
      "gofumpt",

      "markdown-toc",
    },
    auto_update = true,
    run_on_start = false,
    debounce_hours = 24,
  },
}
