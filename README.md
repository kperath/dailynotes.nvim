# dailynotes.nvim 📝

`dailynotes.nvim` allows you to create "daily notes" (notes of the form yyyy-mm-dd.md) and iterate between them.

**Supported file types:** markdown, vimwiki

## Demo
[![asciicast](https://asciinema.org/a/546632.svg)](https://asciinema.org/a/546632)

## Why?
Other notetaking apps like Obsidian and Vscode Foam have this feature and after switching over to vim for notetaking it was one of the features I missed.

## Usage
`:Daily` opens todays daily note

`:DailyNext` opens the next daily note (won't go past todays date)

`:DailyPrev` opens the previous daily note

[if you miss `:NextDaily` and `:PrevDaily`](#legacy)

## Installation
Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

Add `use 'kperath/dailynotes.nvim'` to your packer plugins file.
```lua
require "dailynotes".setup({
    path = '<path to your daily notes>/'
})
```

Using [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'kperath/dailynotes.nvim'

lua << EOF
require "dailynotes".setup({
    path = '<path to your daily notes>/'
})
EOF
```

[If you want to pick a specific tag or branch](#choose-a-different-version--branch)

**Note:** Assuming you have a centralized place where you keep your daily notes, it's recommended to set the `path` or by default your notes will be created in whatever directory you open vim.

### Additional options
Additional options and their default values:
```lua
require "dailynotes".setup({
    ...
    notifications = true,
        -- if disabled no configurations changes will be announced
    legacy = false,
        -- enables v0.1.0 options
    dailyNotesPath = ''
        -- only used if "legacy" is true and "path" is not set
})
```

#### Legacy
Enables backwards compatibility with `v0.1.0` supporting:
- `:NextDaily` command (same as `:DailyNext`)
- `:PrevDaily` command (same as `:DailyPrev`)
- `dailyNotesPath` option (same as `path` which if set takes precedence over this)

## Dev setup
1. clone the repository
2. make your changes
3. from the project root run `nvim --clean --cmd "set rtp+=./"` to open nvim from scratch with only this plugin in the run time path

## Choose a different version / branch
### Packer
```lua
-- branch
use {
    'kperath/dailynotes.nvim',
    branch = '<experimental branch>',
}
-- tag
use {
    'kperath/dailynotes.nvim',
    tag = 'v0.1.0',
}
```

### Vim-Plug
```vim
" branch
Plug 'kperath/dailynotes.nvim', { 'branch': '<experimental branch>' }
" tag
Plug 'kperath/dailynotes.nvim', { 'tag': 'v0.1.0' }
```

## References
This is my first Neovim plugin and besides the documentation, I used the following references:
- ["How to Write Neovim Plugins in Lua"](https://dev.to/2nit/how-to-write-neovim-plugins-in-lua-5cca) which I found [here](https://github.com/nanotee/nvim-lua-guide)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim)

