export LESSCHARSET='utf-8'
export LESS=' -R '
export HISTSIZE=10000
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
export HISTTIMEFORMAT='%Y-%m-%dT%T%z '
export JAVA_HOME=`/usr/libexec/java_home`
export LANG=en_US.UTF-8

alias fuck='networksetup -setairportpower en0 off; sleep 2; networksetup -setairportpower en0 on'
alias less='less -N'
alias ls='ls -G'
alias githubconfig='git config --local user.name ryof; git config --local user.email "ryo.furuyama@gmail.com"'
alias p8='ping 8.8.8.8'
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
if [[ -x $(which gawk) ]]; then alias awk='gawk'; fi
if [[ -x $(which colordiff) ]]; then alias diff='colordiff -u'; fi
if [[ -x $(which gsed) ]]; then alias sed='gsed'; fi

function unzip () {
  $(which unzip) -d ${1%.*} ${1}
}
function peco-select-history() {
  READLINE_LINE=$(HISTTIMEFORMAT= history | tail -r | sed -e 's/^\s*[0-9]\+\s\+//' | awk '!a[$0]++' | peco --layout=bottom-up)
  READLINE_POINT=${#READLINE_LINE}
}

bind -x '"\C-r": peco-select-history'

# OSX-specific
if [[ "$OSTYPE" == "darwin"* ]]; then
	export PATH=/usr/local/opt/openssl/bin:/usr/local/bin:/usr/local/sbin:$HOME/.rbenv/bin:$PATH:~/.nodebrew/current/bin:$HOME/.dotnet
  export DOTNET_ROOT=$HOME/.dotnet
	eval "$(rbenv init -)"

  export PYENV_ROOT=$HOME/.pyenv
  export PATH=$PYENV_ROOT/bin:$PATH
  eval "$(pyenv init --path)"

  export PATH=$PATH:~/.nodebrew/current/bin:/usr/local/lib/node_modules

  # brew options
  export HOMEBREW_CASK_OPTS='--appdir=/Applications'

  # completion settings
  source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
  source $(brew --prefix)/etc/bash_completion.d/git-completion.bash
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
  complete -C "$(brew --prefix)/bin/aws_completer" aws

  # Google Cloud SDK settings
  source $HOME/google-cloud-sdk/path.bash.inc
  source $HOME/google-cloud-sdk/completion.bash.inc

  # other settings
  GIT_PS1_SHOWDIRTYSTATE=true
  export GOPATH=$HOME/.go
  export ANDROID_HOME="/usr/local/share/android-sdk"
  export PATH=$PATH:$GOPATH/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools/bin
  export LESSOPEN="| $(brew --prefix)/bin/src-hilite-lesspipe.sh %s"
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi

# prompt settings
# almost like an imitation of @mathiasbynens 's '.bash_prompt'
# https://github.com/mathiasbynens/dotfiles/blob/master/.bash_prompt
prompt_git() {
  local s='';
  local branchName='';

  # Check if the current directory is in a Git repository.
  if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then
    # check if the current directory is in .git before running git checks
    if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then
      # Ensure the index is up to date.
      git update-index --really-refresh -q &>/dev/null;
      # Check for uncommitted changes in the index.
      if ! $(git diff --quiet --ignore-submodules --cached); then
        s+='+';
      fi;
      # Check for unstaged changes.
      if ! $(git diff-files --quiet --ignore-submodules --); then
        s+='!';
      fi;
      # Check for untracked files.
      if [ -n "$(git ls-files --others --exclude-standard)" ]; then
        s+='?';
      fi;
      # Check for stashed files.
      if $(git rev-parse --verify refs/stash &>/dev/null); then
        s+='$';
      fi;
    fi;

    # Get the short symbolic ref.
    # If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
    # Otherwise, just give up.
    branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
      git rev-parse --short HEAD 2> /dev/null || \
      echo '(unknown)')";

    [ -n "${s}" ] && s=" [${s}]";

    echo -e "${1}${branchName}${2}${s}";
  else
    return;
  fi;
}

bold='';
reset="\e[0m";
white="\e[1;37m";
red="\e[0;31m"
yellow="\e[0;33m"
green="\e[0;32m"
blue="\e[0;34m"
violet="\e[0;35m"

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
  userStyle="${red}";
else
  userStyle="${yellow}";
fi;

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
  hostStyle="${bold}${red}";
else
  hostStyle="${green}";
fi;

# Set the terminal title and prompt.
PS1="\[\033]0;\W\007\]"; # working directory base name
PS1+="\[${bold}\]\n"; # newline
PS1+="\[${userStyle}\]\u"; # username
PS1+="\[${white}\] at ";
PS1+="\[${hostStyle}\]\h"; # host
PS1+="\[${white}\] in ";
PS1+="\[${blue}\]\w"; # working directory full path
PS1+="\$(prompt_git \"\[${white}\] on \[${violet}\]\" \"\[${yellow}\]\") "; # Git repository details
PS1+="\[${white}\]- \t";
PS1+="\n";
PS1+="\[${white}\]$(echo -e '\xF0\x9F\x91\xba')  \[${reset}\]"; # `$` (and reset color)
export PS1;
