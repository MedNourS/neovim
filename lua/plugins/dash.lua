return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          -- 1. Customize your ASCII Header
          header = [[
  .oooooo.                                             .    o8o                                                  
 d8P'  `Y8b                                          .o8    `"'                                                  
888           .ooooo.    oooooooo oooo    ooo      .o888oo oooo  ooo. .oo.  .oo.    .ooooo.   .oooo.o            
888          d88' `88b  d'""7d8P   `88.  .8'         888   `888  `888P"Y88bP"Y88b  d88' `88b d88(  "8            
888          888   888    .d8P'     `88..8'          888    888   888   888   888  888ooo888 `"Y88b.             
`88b    ooo  888   888  .d8P'  .P    `888'           888 .  888   888   888   888  888    .o o.  )88b .o. .o. .o.
 `Y8bood8P'  `Y8bod8P' d8888888P      .8'            "888" o888o o888o o888o o888o `Y8bod8P' 8""888P' Y8P Y8P Y8P
                                  .o..P'                                                                         
                                  `Y8P'                                                                          ]],
          keys = {
            { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.dashboard.pick('projects')" },
            {
              icon = "⚙ ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })",
            },
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        -- 2. Customize the center layout menu items
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
}
