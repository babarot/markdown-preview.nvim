local M = {}

-- Store the process object for the preview server
local preview_process = nil

-- Default configuration
M.config = {
  -- The gh extension command name (default: 'markdown-preview')
  -- Users can change this if they've aliased the extension differently
  gh_cmd = 'markdown-preview',
}

--- Setup function to configure the plugin
--- @param opts table|nil Configuration options
function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})
end

--- Start the markdown preview server
--- @param opts table|nil Options for the preview server
function M.start(opts)
  opts = opts or {}

  -- Check if preview is already running
  if preview_process then
    vim.notify('Markdown preview is already running', vim.log.levels.WARN)
    return
  end

  -- Get the current file path
  local filepath = vim.fn.expand('%:p')

  -- Check if the file is a markdown file
  if vim.bo.filetype ~= 'markdown' then
    vim.notify('Current buffer is not a markdown file', vim.log.levels.ERROR)
    return
  end

  -- Check if the file exists (saved at least once)
  if filepath == '' or vim.fn.filereadable(filepath) == 0 then
    vim.notify('Please save the file before previewing', vim.log.levels.WARN)
    return
  end

  -- Build the command
  local cmd = { 'gh', M.config.gh_cmd, filepath }

  -- Add options
  if opts.dark_mode then
    table.insert(cmd, '--dark-mode')
  elseif opts.light_mode then
    table.insert(cmd, '--light-mode')
  end

  if opts.disable_auto_open then
    table.insert(cmd, '--disable-auto-open')
  end

  if opts.port then
    table.insert(cmd, '--port')
    table.insert(cmd, tostring(opts.port))
  end

  -- Start the preview server
  preview_process = vim.system(cmd, {
    text = true,
    detach = true,
  }, function(obj)
    -- Callback when process exits
    preview_process = nil
    if obj.code ~= 0 then
      vim.schedule(function()
        vim.notify(
          string.format('Markdown preview exited with code %d\nError: %s', obj.code, obj.stderr or 'Unknown error'),
          vim.log.levels.ERROR
        )
      end)
    else
      vim.schedule(function()
        vim.notify('Markdown preview stopped', vim.log.levels.INFO)
      end)
    end
  end)

  vim.notify('Markdown preview started at http://localhost:' .. (opts.port or 3333), vim.log.levels.INFO)
end

--- Stop the markdown preview server
function M.stop()
  if not preview_process then
    vim.notify('No markdown preview is running', vim.log.levels.WARN)
    return
  end

  -- Kill the process
  preview_process:kill(15) -- SIGTERM
  preview_process = nil
  vim.notify('Markdown preview stopped', vim.log.levels.INFO)
end

--- Toggle the markdown preview server
--- @param opts table|nil Options for the preview server
function M.toggle(opts)
  if preview_process then
    M.stop()
  else
    M.start(opts)
  end
end

--- Check if preview is running
--- @return boolean
function M.is_running()
  return preview_process ~= nil
end

return M
