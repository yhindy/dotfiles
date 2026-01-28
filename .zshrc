# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# Homebrew paths (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH=/usr/local/Cellar:$PATH
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"



RED='\033[0;31m'
YELLOW='\e[33m'
NO_COLOR='\033[0m'

# This way the completion script does not have to parse Bazel's options
# repeatedly.  The directory in cache-path must be created manually.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git 
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL10K_DIR_DEFAULT_BACKGROUND='red'
POWERLEVEL10K_DIR_DEFAULT_FOREGROUND='089'
if [[ -n $SSH_CONNECTION ]]; then
    POWERLEVEL10K_LEFT_PROMPT_ELEMENTS=(host dir rbenv virtualenv anaconda vcs)
else
    POWERLEVEL10K_LEFT_PROMPT_ELEMENTS=(dir rbenv virtualenv anaconda vcs)
fi
POWERLEVEL10K_RIGHT_PROMPT_ELEMENTS=(root_indicator status history time)

POWERLEVEL10K_SHORTEN_DIR_LENGTH=2
POWERLEVEL10K_SHORTEN_DELIMITER=""
POWERLEVEL10K_SHORTEN_STRATEGY="truncate_from_right"
POWERLEVEL10K_HIDE_BRANCH_ICON=true
POWERLEVEL10K_VCS_HIDE_TAGS=true
POWERLEVEL10K_PROMPT_ADD_NEWLINE=true
POWERLEVEL10K_SSH_ICON=""
POWERLEVEL10K_STATUS_CROSS=true

POWERLEVEL10K_DIR_HOME_BACKGROUND='red'
POWERLEVEL10K_DIR_HOME_FOREGROUND='089'
POWERLEVEL10K_DIR_HOME_SUBFOLDER_BACKGROUND='red'
POWERLEVEL10K_DIR_HOME_SUBFOLDER_FOREGROUND='089'
POWERLEVEL10K_HOST_REMOTE_BACKGROUND='blue'
POWERLEVEL10K_HOST_REMOTE_FOREGROUND='018'
POWERLEVEL10K_HOST_LOCAL_BACKGROUND='blue'
POWERLEVEL10K_HOST_LOCAL_FOREGROUND='018'
POWERLEVEL10K_VIRTUALENV_BACKGROUND='140'
POWERLEVEL10K_ANACONDA_BACKGROUND='140'
POWERLEVEL10K_RBENV_BACKGROUND='140'

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# fzf
export FZF_DEFAULT_COMMAND='fd --type f'

# Custom
setopt APPEND_HISTORY             # Appends new history to the history file, not overwriting it.
setopt SHARE_HISTORY              # Shares the history across all sessions.
setopt INC_APPEND_HISTORY         # Writes history incrementally to the history file.
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search
bindkey '^[[1;9D' backward-word
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
bindkey '^[D' backward-word
bindkey '^[C' forward-word
bindkey '^[[1;9C' forward-word
bindkey '^R' history-incremental-search-backward
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
if [ -x "$(command -v nvim)" ]; then
  export EDITOR='nvim'
  alias vim='nvim'
else
  export EDITOR='vim'
fi

function rgs() {
  rg -S --pretty -C 2 $@ | less
}
alias rgl="rg -lS"

alias l="ls -lh"
alias ll="ls -alG"

alias crd="claude --resume --dangerously-skip-permissions"
alias cr="claude --resume"
alias c="claude"

alias clawdbot='ssh root@76.13.107.55'

# macOS-specific aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias chrm='open -a "Google Chrome"'
  alias subl='open -a "Sublime Text"'
  alias atom='open -a "Atom"'
  alias mktex='cp ~/template.tex'
fi
alias pynb='jupyter notebook'
alias server='python -m http.server'

alias gds='git diff --staged'
alias gl='glol'
alias gpt='git push --tags'
alias gpf='git push --force-with-lease'
alias gphm='git push heroku main'
alias gu='git pull --rebase'
alias gs='git status'
alias gsh='git stash'
alias ghp='git stash pop'
alias gcm='git commit -m'
alias gca='git commit --amend --no-edit'
alias gk='git checkout'
alias gr='git rebase'
alias gri='git rebase --interactive'
alias grc='git rebase --continue'
alias gts='git tag -l'
alias gta='git tag -a'
alias gap='git add -p'
alias gsh='git stash'
alias gsp='git stash pop'

alias tl='tmux ls'
if [[ "$OSTYPE" == "darwin"* ]]; then
  # iTerm2 tmux integration
  alias tc='tmux -CC'
  alias ta='tmux -CC attach -t'
else
  alias tc='tmux'
  alias ta='tmux attach -t'
fi

alias dps='docker ps -a'
alias dk='docker kill'
alias drm='docker rm -f'
alias di='docker images'
alias drmi='docker rmi'

function error() {
  (>&2 echo -e "${RED}$*${NO_COLOR}")
}

sub() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    find . -type f -exec sed -i '' "s/$1/$2/g" {} +
  else
    find . -type f -exec sed -i "s/$1/$2/g" {} +
  fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# >>> conda initialize >>>
# Check common conda locations
if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    . "$HOME/miniconda3/etc/profile.d/conda.sh"
elif [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
    . "$HOME/anaconda3/etc/profile.d/conda.sh"
elif [ -f "/opt/conda/etc/profile.d/conda.sh" ]; then
    . "/opt/conda/etc/profile.d/conda.sh"
elif [ -d "$HOME/miniconda3/bin" ]; then
    export PATH="$HOME/miniconda3/bin:$PATH"
fi
# <<< conda initialize <<<

source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f ~/.secrets ] && source ~/.secrets
[ -f ~/.lazyshell.zsh ] && source ~/.lazyshell.zsh

# fzf shell integration (better Ctrl+R history search)
if command -v fzf &> /dev/null; then
  eval "$(fzf --zsh)"
  bindkey '^G' fzf-cd-widget
fi

# macOS-specific paths (Homebrew, etc.)
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
  export PATH="$HOME/code/flutter/bin:$PATH"
  export PATH="$PATH":"$HOME/.pub-cache/bin"
  export JAVA_HOME=$(/usr/libexec/java_home -v 21 2>/dev/null)
  [ -n "$JAVA_HOME" ] && export PATH="$JAVA_HOME/bin:$PATH"
  export JAVA_HOME="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
  export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
fi

# Common paths
export PATH="$HOME/.local/bin:$PATH"
