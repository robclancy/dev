if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

zstyle :compinstall filename '/home/robbo/.zshrc'

autoload -Uz compinit
compinit
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

source ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/input/init.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

source <(COMPLETE=zsh jj)

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

bindkey '^R' history-incremental-search-backward

source ~/.config/zsh/functions/wallpaper.zsh

alias ls="ls --color"
alias wiki="cd ~/vimwiki && nvim +VimwikiIndex"
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'

export NPM_CONFIG_PREFIX=$HOME/.local/
export PATH="/home/$USER/go/bin:/home/$USER/.local/bin:$NPM_CONFIG_PREFIX/bin:$PATH"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source ~/p10k-jj-status/p10k-jj-status.plugin.zsh

# pnpm
export PNPM_HOME="/home/robbo/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="/home/robbo/.lando/bin:$PATH"; #landopath
export PATH="$PATH:$HOME/.config/composer/vendor/bin"


# opencode
export PATH=/home/robbo/.opencode/bin:$PATH
