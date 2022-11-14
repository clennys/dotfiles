#███████╗███████╗██╗  ██╗██████╗  ██████╗
#╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#  ███╔╝ ███████╗███████║██████╔╝██║     
# ███╔╝  ╚════██║██╔══██║██╔══██╗██║     
#███████╗███████║██║  ██║██║  ██║╚██████╗
#╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝


source ~/.zsh/antigen.zsh

antigen bundle MichaelAquilina/zsh-auto-notify
antigen bundle hlissner/zsh-autopair
antigen bundle Aloxaf/fzf-tab
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search


# Tell Antigen that you're done
antigen apply

#history
HISTFILE=~/.zsh/zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

bindkey -v

# Personal configuration
source ~/.zsh/aliases.zsh
source ~/.zsh/functions.zsh

# Keybindings

bindkey '^l' autosuggest-accept
    precmd () {
      vcs_info
      print -Pn "\e]0;[%n@%M][%~]\a"
    } 
    preexec () { print -Pn "\e]0;[%n@%M][%~] - ($1)\a" }

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

eval "$(zoxide init zsh)"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.cargo/bin:$PATH"

eval "$(starship init zsh)"
