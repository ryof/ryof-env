function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)'
end

set -x PATH $PATH /usr/local/bin /usr/local/sbin $HOME/.rbenv/shims $HOME/.pyenv/shims $HOME/.nodebrew/current/bin

# rbenv configuration
set -gx RBENV_SHELL fish
source '/usr/local/Cellar/rbenv/1.1.1/libexec/../completions/rbenv.fish'
command rbenv rehash 2>/dev/null
function rbenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    source (rbenv "sh-$command" $argv|psub)
  case '*'
    command rbenv "$command" $argv
  end
end

# pyenv configuration
set -gx PYENV_SHELL fish
source '/usr/local/Cellar/pyenv/1.1.3/libexec/../completions/pyenv.fish'
command pyenv rehash 2>/dev/null
function pyenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    source (pyenv "sh-$command" $argv|psub)
  case '*'
    command pyenv "$command" $argv
  end
end
