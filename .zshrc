export LESSCHARSET='utf-8'
export LESS=' -R '
export HISTSIZE=10000
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT='%Y-%m-%dT%T%z '
export LANG=en_US.UTF-8
export GPG_TTY=$TTY
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

alias fuck='networksetup -setairportpower en0 off; sleep 2; networksetup -setairportpower en0 on'
alias less='less -N'
alias ls='ls -G'
alias p8='ping 8.8.8.8'

source "$(brew --prefix asdf)/libexec/asdf.sh"
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

source /opt/homebrew/opt/zsh-git-prompt/zshrc.sh

git_prompt() {
  if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = true ]; then
    PROMPT='%B%F{yellow}%n %F{white}at %F{green}%m %F{white}in %F{blue}%~ %b%f $(git_super_status)'
  else
    PROMPT='%B%F{yellow}%n %F{white}at %F{green}%m %F{white}in %F{blue}%~ %b%f'
  fi
  PROMPT+=$'\n'"👺 "
}

precmd() {
  git_prompt
  echo
}

_ssh() {
  compadd `fgrep 'Host ' ~/.ssh/config | awk '{print $2}' | sort`;
}

peco-history-selection() {
  BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | peco --layout=bottom-up`
  CURSOR=$#BUFFER
  zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection
