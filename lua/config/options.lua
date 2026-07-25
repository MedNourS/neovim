-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Set the global colorscheme for LazyVim
vim.g.lazyvim_colorscheme = "catppuccin"

-- Global JIT Performance Tweaks
if jit then
  -- Maximize memory allocation sizes for compiled Lua loops
  jit.opt.start("maxmcode=8192", "maxtrace=4000")
end

-- Decrease input timeout delays (Makes key triggers instant)
vim.o.timeoutlen = 300 -- Wait 300ms instead of 1000ms for mapping combinations
vim.o.updatetime = 200 -- Refreshes git gutters and trees in 200ms
