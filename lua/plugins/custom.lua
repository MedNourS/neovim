return {
  -- 1. Configure Catppuccin flavor
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "frappe",
      transparent_background = true,
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        neotree = true,
        treesitter = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-frappe")
    end,
  },

  -- 2. Configure Tab completion
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- vim.tbl_deep_extend ensures we don't overwrite LazyVim's default icons or spacing
      opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
        menu = {
          min_width = 30,
          max_height = 15,
          border = "rounded",
          -- This is the magic line: it forces the border to use the standard Neovim "FloatBorder"
          -- color instead of the potentially invisible blink border color.
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        },
        documentation = {
          window = {
            border = "rounded",
            -- Same fix for the documentation window
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
          },
        },
      })
    end,
  },

  -- 3. Add ToggleTerm for your Vite/Network debugging
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = [[<c-/>]],
      direction = "float",
    },
  },

  -- 4. Add Harpoon for project navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
    end,
    keys = {
      {
        "<leader>ha",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon add file",
      },
      {
        "<leader>hh",
        function()
          require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
        end,
        desc = "Harpoon toggle menu",
      },
    },
  },
}
