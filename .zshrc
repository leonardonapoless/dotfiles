export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


alias zf="zigfetch"


# ---- Yazi Setup ----

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

export EDITOR=nvim

# ------ Load ZSH Auto-Suggestions Plugin ------
#ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd

#source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

#bindkey '^I' autosuggest-accept

#bindkey '\e[C' complete-word


export PATH=$PATH:$HOME/go/bin


# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/leonardonapoles/.lmstudio/bin"
# End of LM Studio CLI section


# Added by Antigravity
export PATH="/Users/leonardonapoles/.antigravity/antigravity/bin:$PATH"
