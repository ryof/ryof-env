alias fuck='networksetup -setairportpower en0 off; sleep 2; networksetup -setairportpower en0 on'
alias less='less -N'
alias ls='ls -G'

function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)'
end

set -x PATH $PATH /usr/local/bin /usr/local/sbin $HOME/.nodebrew/current/bin

# pyenv/rbenv configuration
status --is-interactive; and source (pyenv init -|psub)
status --is-interactive; and source (rbenv init -|psub)
