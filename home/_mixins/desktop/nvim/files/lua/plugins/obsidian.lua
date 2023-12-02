return {
  "epwalsh/obsidian.nvim",
  lazy = true,
  keys = {
    { "<leader>ng", "<cmd>ObsidianQuickSwitch<cr>", desc = "Grep in Notes" },
    { "<leader>nf", "<cmd>ObsidianSearch<cr>", desc = "Find filenames in Notes" },
    { "<leader>nn", "<cmd>ObsidianNew<cr>", desc = "Create new Note" },
    { "<leader>nt", "<cmd>ObsidianToday<cr>", desc = "Open Daily Note" },
    { "<leader>ny", "<cmd>ObsidianYesterday<cr>", desc = "Open Yesterdays Note" },
    { "<leader>ny", "<cmd>ObsidianYesterday<cr>", desc = "Open Yesterdays Note" },
  },
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    "BufReadPre "
      .. vim.fn.expand("~")
      .. "/notes/**.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/notes/**.md",
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "Private",
        path = "~/notes/priv/",
      },
      {
        name = "Ixolit",
        path = "~/notes/ixo/",
      },
      {
        name = "Ixopay",
        path = "~/notes/pay/",
      },
      {
        name = "Vault",
        path = "~/notes/vau/",
      },
    },
    templates = {
      subdir = "templates",
      date_format = "%a %d-%m-%Y",
      time_format = "%H:%M",
    },
    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = "archive",
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = "%Y-%m-%d",
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = "%B %-d, %Y",
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = "daily.md",
    },
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
    },

    -- see below for full list of options 👇
  },
}
