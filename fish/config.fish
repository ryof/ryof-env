alias fuck='networksetup -setairportpower en0 off; sleep 2; networksetup -setairportpower en0 on'
alias less='less -N'
alias ls='ls -G'
alias sed='gsed'
alias p8='ping 8.8.8.8'

function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)'
end

set -x PATH $PATH /usr/local/bin /usr/local/sbin $HOME/.nodebrew/current/bin
set -x LESSCHARSET utf-8
set -x HISTSIZE 10000
set -x HISTFILESIZE $HISTSIZE
set -x HISTCONTROL ignoredups
set -x LANG en_US.UTF-8

# pyenv/rbenv configuration
status --is-interactive; and source (pyenv init -|psub)
status --is-interactive; and source (rbenv init -|psub)
