# dailynotes.nvim 📝

`dailynotes.nvim` allows you to create "daily notes" (notes of the form yyyy-mm-dd.md) and iterate between them.

**Supported file types:** markdown, vimwiki

## Demo
[![asciicast](https://asciinema.org/a/G3NQAVbO0iJays5xIfi8Ej8Yv.svg)](https://asciinema.org/a/G3NQAVbO0iJays5xIfi8Ej8Yv)

## Why?
Other notetaking apps like Obsidian and Vscode Foam have this feature and after switching over to vim for notetaking it was one of the features I missed.

## Usage
`:Daily` opens todays daily note

`:NextDaily` opens the next daily note
  - Won't create a new file for the next day if one does not exist
  - Won't go past todays date

`:PrevDaily` opens the previous daily note
  - Won't create a file if one does not exist

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

**Note:** Assuming you have a centralized place where you keep your daily notes, it's recommended to set the `path` or by default your notes will be created in whatever directory you open vim.

## Dev setup
1. clone the repository
2. make your changes
3. from the project root run `nvim --cmd "set rtp+=./"` to open vim with the plugin in the run time path

## References
This is my first Neovim plugin and besides the documentation, I used the following references:
- ["How to Write Neovim Plugins in Lua"](https://dev.to/2nit/how-to-write-neovim-plugins-in-lua-5cca) which I found [here](https://github.com/nanotee/nvim-lua-guide)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim)

