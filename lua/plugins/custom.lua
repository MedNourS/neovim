return {

  -- Increase Git clone timeout to allow slow connections to finish cleanly
  {
    "folke/lazy.nvim",
    opts = {
      git = {
        timeout = 300,
      },
    },
  },

  -- Optimize internal module caching for faster load times
  {
    "LazyVim/LazyVim",
    opts = {
      cache = { enabled = true },
    },
  },

  -- Configure Linters to trigger explicitly on File Save
  {
    "mfussenegger/nvim-lint",
    opts = {
      -- This forces the linter to re-run your background tests every time you write to disk
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    },
  },

  -- Smooth Scrolling Animations
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at end of file
        easing_function = "quadratic", -- Smooth cinematic acceleration curves
      })
    end,
  },

  -- Custom High-Density Which-Key Visual Layout
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- 1. Switches layout style from old-school lines to clean pillars
      preset = "modern",

      -- 2. Performance speedup: Reduces panel delay from 500ms to 200ms
      delay = 200,

      win = {
        -- Borders style choice: "none", "single", "double", or "rounded"
        border = "rounded",
        title = true,
        title_pos = "center",
      },
      icons = {
        breadcrumb = "»", -- character used in the command line area separator
        separator = "➜", -- symbol pointing from your hotkey to the description
        group = "+", -- prefix indicator for folders/sub-menus
      },
      layout = {
        spacing = 3, -- spacing between visual columns
      },
    },
  },

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
      opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
        menu = {
          min_width = 30,
          max_height = 15,
          border = "rounded",
          winhighlight = "Normal:BlinkCmpMenu,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        },
        documentation = {
          window = {
            border = "rounded",
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

  -- 5. Native Image support for Ghostty via Snacks
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      image = {
        enabled = true,
        doc = {
          inline = true,
          float = true,
          max_width = 60,
          max_height = 30,
        },
      },
    },
  },

  -- 6. Edit your file system like a text buffer
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      default_file_explorer = true,
      columns = { "icon" },
      view_options = { show_hidden = true },
    },
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory in Oil" },
    },
  },

  -- 7. Advanced increment/decrement (booleans, hex, dates)
  {
    "monaqa/dial.nvim",
    keys = {
      {
        "<C-a>",
        function()
          return require("dial.map").inc_normal()
        end,
        expr = true,
        desc = "Increment",
      },
      {
        "<C-x>",
        function()
          return require("dial.map").dec_normal()
        end,
        expr = true,
        desc = "Decrement",
      },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true }),
        },
      })
    end,
  },

  -- 8. Instant Code Block Slider
  {
    "nvim-mini/mini.move",
    version = "*",
    opts = {
      mappings = {
        left = "<H>",
        right = "<L>",
        down = "<J>",
        up = "<K>",
        line_left = "<H>",
        line_right = "<L>",
        line_down = "<J>",
        line_up = "<K>",
      },
    },
  },

  -- 9. Fast Text Swapper (Rebound to 'X' to avoid layout fighting with flash.nvim)
  {
    "gbprod/substitute.nvim",
    opts = {},
    keys = {
      {
        "X",
        function()
          require("substitute").operator()
        end,
        desc = "Substitute motion",
      },
      {
        "XX",
        function()
          require("substitute").line()
        end,
        desc = "Substitute line",
      },
      {
        "X",
        function()
          require("substitute").visual()
        end,
        mode = "x",
        desc = "Substitute visual",
      },
    },
  },

  -- 10. System Clipboard Images Paster (Launches lazily on keypress)
  {
    "HakonHarnes/img-clip.nvim",
    keys = {
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
    },
    opts = {
      default = {
        embed_image_as_markdown = true,
        use_absolute_path = false,
      },
    },
  },
}
