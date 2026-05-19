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

airpods() {
  local mode="${1:-1}"
  local mac="D0:3E:07:DF:9A:56"
  local device_path="/org/bluez/hci1/dev_D0_3E_07_DF_9A_56"
  local sink_base="bluez_output.D0_3E_07_DF_9A_56"
  local sink=""
  local state_file="${XDG_RUNTIME_DIR:-/tmp}/airpods-prev-sink"
  local previous_sink=""
  local current_default=""
  local waited=0
  local sink_input_id _

  if [[ "$mode" == "0" ]]; then
    if [[ -f "$state_file" ]]; then
      previous_sink="$(<"$state_file")"
    fi

    busctl call org.bluez "$device_path" org.bluez.Device1 Disconnect >/dev/null || return 1

    if [[ -n "$previous_sink" ]]; then
      pactl set-default-sink "$previous_sink"

      while IFS=$'\t' read -r sink_input_id _; do
        [[ -n "$sink_input_id" ]] && pactl move-sink-input "$sink_input_id" "$previous_sink"
      done < <(pactl list short sink-inputs)

      rm -f "$state_file"
    fi

    return 0
  fi

  busctl call org.bluez "$device_path" org.bluez.Device1 Connect >/dev/null || return 1

  while (( waited < 15 )); do
    sink="$(pactl list short sinks | grep -o "${sink_base}\.[^[:space:]]*" | head -n 1)"

    if [[ -n "$sink" ]]; then
      current_default="$(pactl get-default-sink 2>/dev/null || true)"
      if [[ -n "$current_default" && "$current_default" != "$sink" ]]; then
        printf '%s\n' "$current_default" > "$state_file"
      fi

      pactl set-default-sink "$sink"

      while IFS=$'\t' read -r sink_input_id _; do
        [[ -n "$sink_input_id" ]] && pactl move-sink-input "$sink_input_id" "$sink"
      done < <(pactl list short sink-inputs)

      return 0
    fi

    sleep 1
    (( waited++ ))
  done

  print -u2 "AirPods connected, but sink '$sink' was not found"
  return 1
}

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
