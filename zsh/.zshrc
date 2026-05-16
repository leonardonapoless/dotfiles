autoload -Uz compinit
compinit

# Completion styles 
zstyle ':completion:*' menu select                        # interactive menu with arrow keys
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case-insensitive matching
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}     # colorize completions like ls
zstyle ':completion:*' group-name ''                      # group results by category
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'
zstyle ':completion:*' squeeze-slashes true                # treat // as /
zstyle ':completion:*' complete-options true
zstyle ':completion:*' rehash true                        # pick up new binaries automatically
setopt COMPLETE_ALIASES                                   # complete aliased commands

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

alias zf="zigfetch"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

export EDITOR=nvim

export PATH=$PATH:$HOME/go/bin

# Angular CLI completion
if command -v ng > /dev/null 2>&1; then
  source <(ng completion script)
fi

# bun completions
[ -s "/Users/leonardonapoles/.bun/_bun" ] && source "/Users/leonardonapoles/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
alias idea="open -na \"IntelliJ IDEA.app\" --args"

# zoxide
if command -v zoxide > /dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# Added by Antigravity
export PATH="/Users/leonardonapoles/.antigravity/antigravity/bin:$PATH"
