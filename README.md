## Dotfiles

Config files for zsh, vim, tmux, and git.

### Quick Setup (VPS/New Machine)

```bash
curl -fsSL https://raw.githubusercontent.com/yhindy/dotfiles/master/install.sh | bash
```

This installs everything: zsh, oh-my-zsh, powerlevel10k, plugins, and symlinks configs.

For manual setup or to update existing install:
```bash
git clone https://github.com/yhindy/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./setup.sh
```

### Optional Tools

For better search (`Ctrl+R`, `Ctrl+G`):
```bash
# Ubuntu/Debian
sudo apt-get install fzf fd-find

# macOS
brew install fzf fd
```

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
