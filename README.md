## Dotfiles

Config files for zsh, vim, tmux, and git.

### Quick Setup (VPS/New Machine)

```bash
git clone https://github.com/yhindy/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && chmod +x setup.sh && ./setup.sh
```

This clones the repo to `~/.dotfiles` and symlinks configs to your home directory.

### Prerequisites

For full functionality, install:
- [oh-my-zsh](https://ohmyz.sh/)
- [powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [fzf](https://github.com/junegunn/fzf) (optional, for better Ctrl+R)
- [fd](https://github.com/sharkdp/fd) (optional, for fzf file finding)

### What's Included

| File | Description |
|------|-------------|
| `.zshrc` | Zsh config with aliases, prompt, and cross-platform support |
| `.vimrc` | Vim/Neovim config |
| `.tmux.conf` | Tmux config with vim-style bindings |
| `.gitconfig` | Git config with useful defaults |
| `.gitignore_global` | Global gitignore |

### Cross-Platform Support

The `.zshrc` automatically detects macOS vs Linux and adjusts:
- Homebrew paths (macOS only)
- `sed` syntax (BSD vs GNU)
- iTerm2 tmux integration (macOS only)
- macOS `open` command aliases

### Terminal Configuration

Colors:
- foreground: `#fffeeb`
- background: `#132132`
- black: `#3c3c3c`
- red: `#fd8489`
- green: `#a9dd9d`
- yellow: `#fedf81`
- blue: `#86acd7`
- magenta: `#e7d5ff`
- cyan: `#a8d2eb`
- white: `#ededed`

Font: [Roboto Mono](https://github.com/powerline/fonts/tree/master/RobotoMono)

### Hammerspoon (macOS)

The `hammerspoon/` folder contains window management scripts. Symlink `init.lua` to `~/.hammerspoon/` to use.
