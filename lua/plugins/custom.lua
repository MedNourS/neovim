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

  -- =========================================================================
  -- 🚀 FULL-STACK, SECURITY & HACKATHON LANGUAGE TOOLING SETUP
  -- =========================================================================

  -- 1. Tell Mason to auto-install your full language and security stack
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- LSPs (Backend, Frontend, Configs)
        "jdtls",
        "omnisharp",
        "vtsls",
        "html-lsp",
        "css-lsp",
        "basedpyright",
        "intelephense",
        "sqlls",
        -- Cybersecurity Scanners
        "trivy",
        "semgrep",
        -- Linters & Formatters
        "google-java-format",
        "csharpier",
        "php-cs-fixer",
        "sql-formatter",
        "markdownlint",
        "hadolint",
        "black",
      })
    end,
  },

  -- 2. Register your new Language Servers (LSPs) into LazyVim's native system
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jdtls = {},
        omnisharp = {},
        vtsls = {}, -- Modern, faster TS server option
        html = {},
        cssls = {},
        intelephense = {},
        sqlls = {},

        basedpyright = {
          -- 🚀 FIX 1: Intercept the server attachment and completely silence the progress handler
          on_attach = function(client, _)
            client.handlers["$/progress"] = function() end
          end,
          settings = {
            basedpyright = {
              analysis = {
                -- 🚀 FIX 2: Cuts down on harsh academic type rules for faster hackathon coding
                typeCheckingMode = "standard",
                -- 🚀 FIX 3: Limits background memory scans strictly to open project buffers
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
      },
    },
  },

  -- 3. Configure file formatters to run beautifully behind the scenes
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" },
        python = { "black" },
        java = { "google-java-format" },
        cs = { "csharpier" },
        php = { "php-cs-fixer" },
        sql = { "sql-formatter" },
      },
    },
  },

  -- 4. Set up Linters and define custom Semgrep security specifications
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- 1. Keep your file save triggers active
      opts.events = { "BufWritePost", "BufReadPost", "InsertLeave" }

      -- 2. Bind languages to your linters
      opts.linters_by_ft = {
        markdown = { "markdownlint" },
        javascript = { "semgrep" },
        typescript = { "semgrep" },
        python = { "semgrep" },
      }

      -- 3. 🚀 TEACH NVIM-LINT HOW TO RUN SEMGREP
      opts.linters = opts.linters or {}
      opts.linters.semgrep = {
        cmd = "semgrep",
        stdin = false, -- Semgrep needs full file paths to run scanning rules
        args = {
          "--quiet",
          "--config=auto", -- Automatically applies standard web/security rules
          "--json", -- Passes clean structural text back to Neovim
        },
        stream = "stdout",
        ignore_exitcode = true, -- Stops Neovim from throwing crash errors if bugs are found

        -- Tells Neovim how to read Semgrep's JSON object and turn them into red lines
        parser = function(output, bufnr)
          if output == "" or output == nil then
            return {}
          end
          local decoded = vim.json.decode(output)
          if not decoded or not decoded.results then
            return {}
          end

          local diagnostics = {}
          for _, match in ipairs(decoded.results) do
            table.insert(diagnostics, {
              source = "semgrep",
              lnum = match.start.line - 1,
              col = match.start.col - 1,
              end_lnum = match["end"].line - 1,
              end_col = match["end"].col - 1,
              severity = match.extra.severity == "ERROR" and vim.diagnostic.severity.ERROR
                or vim.diagnostic.severity.WARN,
              message = match.extra.message,
            })
          end
          return diagnostics
        end,
      }
    end,
  },

  -- =========================================================================
  -- 🎨 VISUALS, QUALITY OF LIFE & UTILITY PLUGINS (PRESERVED)
  -- =========================================================================

  -- Smooth Scrolling Animations
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true,
        stop_eof = true,
        easing_function = "quadratic",
      })
    end,
  },

  -- Custom High-Density Which-Key Visual Layout
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 200,
      win = {
        border = "rounded",
        title = true,
        title_pos = "center",
      },
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      layout = {
        spacing = 3,
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

  -- 7. Workspace Project Manager optimized natively for ~/Documents/Code
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          projects = {
            -- Automatically treats subdirectories in your Code folder as available projects
            dev = { "~/Documents/Code" },
            patterns = { ".git", "Makefile", "package.json", "pyproject.toml" },
          },
        },
      },
    },
    keys = {
      {
        "<leader>fp",
        function()
          -- Launches LazyVim's lightning-fast native project switcher window
          Snacks.picker.projects()
        end,
        desc = "Find Projects",
      },
    },
  },

  -- 8. Advanced increment/decrement (booleans, hex, dates)
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

  -- 9. Instant Code Block Slider
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

  -- 10. Fast Text Swapper (Rebound to 'X' to avoid layout fighting with flash.nvim)
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

  -- 11. System Clipboard Images Paster (Launches lazily on keypress)
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

  -- 12. Free Cloud Models via OpenRouter
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    build = "make",
    opts = function()
      local options = {
        provider = "openrouter_smart",
        auto_suggestions_provider = "openrouter_fast",
        cursor_applying_provider = "openrouter_fast",

        input = {
          provider = "dressing",
        },

        providers = {
          openrouter_smart = {
            __inherited_from = "openai",
            endpoint = "https://openrouter.ai/api/v1",
            model = "inclusionai/ling-3.0-flash:free",
            api_key_name = "OPENROUTER_API_KEY",
            extra_curl_args = {
              "-H",
              "HTTP-Referer: https://github.com/yetone/avante.nvim",
              "-H",
              "X-Title: Neovim Avante",
            },
          },
          openrouter_fast = {
            __inherited_from = "openai",
            endpoint = "https://openrouter.ai/api/v1",
            model = "poolside/laguna-xs-2.1:free",
            api_key_name = "OPENROUTER_API_KEY",
            extra_curl_args = {
              "-H",
              "HTTP-Referer: https://github.com/yetone/avante.nvim",
              "-H",
              "X-Title: Neovim Avante",
            },
          },
        },
        custom_tools = {},
      }

      -- Safely attempt to load MCP Hub.
      -- If it's not installed yet, this fails silently and lets Lazy finish the install & bun build.
      local mcp_ok, mcp_avante = pcall(require, "mcphub.extensions.avante")
      if mcp_ok then
        options.custom_tools = {
          mcp_avante.mcp_tool("planning", function()
            return require("avante.utils").get_project_root()
          end),
        }
      end

      return options
    end,

    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",

      -- Model Context Protocol (MCP) Hub for Neovim
      {
        "ravitemer/mcphub.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        build = "bun add -g mcp-hub@latest",
        config = function()
          require("mcphub").setup()
        end,
      },
    },
  },
}
