# markdown-preview.nvim

A Neovim plugin for previewing Markdown files using [gh-markdown-preview](https://github.com/yusukebe/gh-markdown-preview). This plugin provides a seamless integration with GitHub's official Markdown API to preview your Markdown files with the exact same styling as GitHub.

## Features

- GitHub-style Markdown rendering
- Live reload on file save
- Automatic browser opening
- Process lifecycle management (auto-cleanup on Neovim exit)
- Support for dark/light mode
- Customizable port and options
- Built with modern Neovim APIs (`vim.system`)

## Requirements

- Neovim 0.10+
- [GitHub CLI (`gh`)](https://cli.github.com/)
- [gh-markdown-preview](https://github.com/yusukebe/gh-markdown-preview) extension

## Installation

### Install gh-markdown-preview first

```bash
gh extension install yusukebe/gh-markdown-preview
```

### Install the plugin

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'babarot/markdown-preview.nvim',
  ft = 'markdown',
  config = function()
    -- Optional: Configure the plugin
    require('markdown-preview').setup({
      -- The gh extension command name (change if you've aliased it differently)
      gh_cmd = 'markdown-preview',  -- default value
    })

    -- Optional: Set up keymaps
    vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<cr>', { desc = 'Markdown Preview' })
    vim.keymap.set('n', '<leader>ms', '<cmd>MarkdownPreviewStop<cr>', { desc = 'Markdown Preview Stop' })
    vim.keymap.set('n', '<leader>mt', '<cmd>MarkdownPreviewToggle<cr>', { desc = 'Markdown Preview Toggle' })
  end,
}
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'babarot/markdown-preview.nvim',
  ft = 'markdown',
}
```

Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'babarot/markdown-preview.nvim', { 'for': 'markdown' }
```

## Usage

### Commands

#### `:MarkdownPreview [options]`

Start the markdown preview server for the current buffer.

**Options:**
- `--dark-mode` or `-d`: Force dark mode
- `--light-mode` or `-l`: Force light mode
- `--disable-auto-open`: Disable automatic browser opening
- `--port=<number>`: Specify custom port (default: 3333)

**Examples:**
```vim
:MarkdownPreview
:MarkdownPreview --dark-mode
:MarkdownPreview --port=8080
:MarkdownPreview --dark-mode --disable-auto-open
```

#### `:MarkdownPreviewStop`

Stop the markdown preview server.

#### `:MarkdownPreviewToggle [options]`

Toggle the markdown preview server. Accepts the same options as `:MarkdownPreview`.

## Configuration

You can configure the plugin using the `setup()` function:

```lua
require('markdown-preview').setup({
  -- The gh extension command name
  -- Change this if you've aliased the gh-markdown-preview extension differently
  -- Default: 'markdown-preview'
  gh_cmd = 'markdown-preview',
})
```

### Why is this configurable?

The gh extension command name can vary depending on how users have installed or aliased it:
- Default installation: `gh markdown-preview` (full name)
- Some users may have: `gh md` (short alias)
- Custom aliases are also possible

### Lua API

You can also use the Lua API directly:

```lua
local markdown_preview = require('markdown-preview')

-- Configure first (optional)
markdown_preview.setup({
  gh_cmd = 'markdown-preview',  -- or 'md' if you've aliased it to the short version
})

-- Start preview
markdown_preview.start()

-- Start with options
markdown_preview.start({
  dark_mode = true,
  port = 8080,
  disable_auto_open = false,
})

-- Stop preview
markdown_preview.stop()

-- Toggle preview
markdown_preview.toggle()

-- Check if preview is running
if markdown_preview.is_running() then
  print('Preview is running')
end
```

### Recommended Keymaps

Add these to your Neovim configuration:

```lua
vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<cr>', { desc = 'Markdown Preview' })
vim.keymap.set('n', '<leader>ms', '<cmd>MarkdownPreviewStop<cr>', { desc = 'Markdown Preview Stop' })
vim.keymap.set('n', '<leader>mt', '<cmd>MarkdownPreviewToggle<cr>', { desc = 'Markdown Preview Toggle' })
```

## How It Works

1. When you run `:MarkdownPreview`, the plugin starts a `gh markdown-preview` server process using `vim.system()`
2. The server watches your Markdown file and automatically reloads the preview when you save changes
3. Your default browser opens automatically (unless `--disable-auto-open` is used)
4. The preview server runs in the background and is automatically stopped when you exit Neovim

## Troubleshooting

### "gh CLI is not installed"

Install GitHub CLI from https://cli.github.com/

### "gh-markdown-preview extension not found"

Install the extension:
```bash
gh extension install yusukebe/gh-markdown-preview
```

### "Neovim 0.10+ required"

Update your Neovim to version 0.10 or later:
```bash
# macOS
brew upgrade neovim

# Or download from https://github.com/neovim/neovim/releases
```

### Port already in use

Specify a different port:
```vim
:MarkdownPreview --port=8080
```

## License

MIT

## Credits

- [gh-markdown-preview](https://github.com/yusukebe/gh-markdown-preview) by [Yusuke Wada](https://github.com/yusukebe)
