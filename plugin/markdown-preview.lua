-- markdown-preview.nvim
-- A Neovim plugin for previewing markdown files using gh-markdown-preview

-- Prevent the plugin from being loaded multiple times
if vim.g.loaded_markdown_preview then
  return
end
vim.g.loaded_markdown_preview = true

-- Check if Neovim version is at least 0.10
if vim.fn.has('nvim-0.10') == 0 then
  vim.notify('markdown-preview.nvim requires Neovim 0.10+', vim.log.levels.ERROR)
  return
end

-- Check if gh CLI is available
if vim.fn.executable('gh') == 0 then
  vim.notify('markdown-preview.nvim requires gh CLI to be installed', vim.log.levels.ERROR)
  return
end

local markdown_preview = require('markdown-preview')

-- Create user commands
vim.api.nvim_create_user_command('MarkdownPreview', function(cmd_opts)
  local opts = {}

  -- Parse command arguments
  for _, arg in ipairs(cmd_opts.fargs) do
    if arg == '--dark-mode' or arg == '-d' then
      opts.dark_mode = true
    elseif arg == '--light-mode' or arg == '-l' then
      opts.light_mode = true
    elseif arg == '--disable-auto-open' then
      opts.disable_auto_open = true
    elseif arg:match('^--port=') then
      opts.port = tonumber(arg:match('^--port=(.+)'))
    end
  end

  markdown_preview.start(opts)
end, {
  nargs = '*',
  desc = 'Start markdown preview server',
})

vim.api.nvim_create_user_command('MarkdownPreviewStop', function()
  markdown_preview.stop()
end, {
  desc = 'Stop markdown preview server',
})

vim.api.nvim_create_user_command('MarkdownPreviewToggle', function(cmd_opts)
  local opts = {}

  -- Parse command arguments
  for _, arg in ipairs(cmd_opts.fargs) do
    if arg == '--dark-mode' or arg == '-d' then
      opts.dark_mode = true
    elseif arg == '--light-mode' or arg == '-l' then
      opts.light_mode = true
    elseif arg == '--disable-auto-open' then
      opts.disable_auto_open = true
    elseif arg:match('^--port=') then
      opts.port = tonumber(arg:match('^--port=(.+)'))
    end
  end

  markdown_preview.toggle(opts)
end, {
  nargs = '*',
  desc = 'Toggle markdown preview server',
})

-- Auto-stop preview when Neovim exits
vim.api.nvim_create_autocmd('VimLeavePre', {
  group = vim.api.nvim_create_augroup('MarkdownPreviewCleanup', { clear = true }),
  callback = function()
    if markdown_preview.is_running() then
      markdown_preview.stop()
    end
  end,
})
