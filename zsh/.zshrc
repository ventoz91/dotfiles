# ~/.zshrc

export PATH="$HOME/.local/bin:$PATH"

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Completion
autoload -Uz compinit && compinit

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY

# Options
setopt AUTO_CD

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lahF'
alias grep='grep --color=auto'
alias vi='nvim'
alias vim='nvim'

# fzf — fuzzy finder (Ctrl+R history, Ctrl+T file search, Alt+C cd)
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --color=bg+:#1a1a1a,bg:#141414,spinner:#33ccff,hl:#33ccff,fg:#cdd6f4,header:#33ccff,info:#00ff99,pointer:#33ccff,marker:#00ff99,fg+:#cdd6f4,prompt:#33ccff,hl+:#00ff99'

# zoxide — frecency-based directory jumping (replaces cd)
eval "$(zoxide init zsh --cmd cd)"

fastfetch

eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/config.toml)"
