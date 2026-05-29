#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
eval "$(oh-my-posh init bash --config ~/.config/ohmyposh/config.toml)"
alias vi='nvim'
alias vim='nvim'

if [[ $- == *i* ]]; then
	fastfetch
fi

export PATH="$HOME/.local/bin:$PATH"

alias dn='python3 ~/Documents/Projects/Daily/daily.py'
