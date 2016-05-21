export LESSCHARSET='utf-8'
export LESS=' -R '
export HISTSIZE=10000
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups

alias awk='gawk'
alias fuck='networksetup -setairportpower en0 off; sleep 2; networksetup -setairportpower en0 on'
alias less='less -N'
alias ls='ls -G'
alias githubconfig='git config --local user.name ryof; git config --local user.email "ryo.furuyama@gmail.com"'
function ssh_function () {
	if type sshrc > /dev/null; then
		cat ~/.bash_profile > ~/.sshrc
		mkdir -p ~/.sshrc.d
		if [ ! -e ~/.sshrc.d/.vimrc ]; then
			ln -s ~/.vimrc ~/.sshrc.d/.vimrc
		fi
		cat << 'EOF' >> ~/.sshrc
export VIMINIT="let \$MYVIMRC='$SSHHOME/.sshrc.d/.vimrc' | source \$MYVIMRC"
EOF
		sshrc "$*"
	else
		$(which ssh) "$*"
	fi
}
alias ssh='ssh_function'
function unzip () {
	$(which unzip) -d ${1%.*} ${1}
}
# OSX-specific
if [[ "$OSTYPE" == "darwin"* ]]; then
	export PATH=/opt/brew/bin:/opt/brew/sbin:$HOME/.rbenv/bin:$PATH
	eval "$(rbenv init -)"
	
	export PYENV_ROOT=$HOME/.pyenv
	export PATH=$PYENV_ROOT/bin:$PATH
	eval "$(pyenv init -)"

	# brew options
	export HOMEBREW_CASK_OPTS='--appdir=/Applications'

	# completion settings
	source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
	source $(brew --prefix)/etc/bash_completion.d/git-completion.bash
	if [ -f $(brew --prefix)/etc/bash_completion ]; then
		. $(brew --prefix)/etc/bash_completion
	fi

	# Google Cloud SDK settings
	source $HOME/google-cloud-sdk/path.bash.inc
	source $HOME/google-cloud-sdk/completion.bash.inc

	GIT_PS1_SHOWDIRTYSTATE=true
	export GOPATH=$HOME/.go

	export LESSOPEN="| $(brew --prefix)/bin/src-hilite-lesspipe.sh %s"
fi

# prompt settings
# almost like an imitation of @mathiasbynens 's '.bash_prompt'
#	https://github.com/mathiasbynens/dotfiles/blob/master/.bash_prompt
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

if tput setaf 1 &> /dev/null; then
	tput sgr0; # reset colors
	bold=$(tput bold);
	reset=$(tput sgr0);
	# Solarized colors, taken from http://git.io/solarized-colors.
	black=$(tput setaf 0);
	blue=$(tput setaf 33);
	cyan=$(tput setaf 37);
	green=$(tput setaf 64);
	orange=$(tput setaf 166);
	purple=$(tput setaf 125);
	red=$(tput setaf 124);
	violet=$(tput setaf 61);
	white=$(tput setaf 15);
	yellow=$(tput setaf 136);
else
	bold='';
	reset="\e[0m";
	black="\e[1;30m";
	blue="\e[1;34m";
	cyan="\e[1;36m";
	green="\e[1;32m";
	orange="\e[1;33m";
	purple="\e[1;35m";
	red="\e[1;31m";
	violet="\e[1;35m";
	white="\e[1;37m";
	yellow="\e[1;33m";
fi;

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	userStyle="${red}";
else
	userStyle="${orange}";
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
PS1+="\$(prompt_git \"\[${white}\] on \[${violet}\]\" \"\[${yellow}\]\")"; # Git repository details
PS1+="\n";
PS1+="\[${white}\]$(echo -e '\xF0\x9F\x91\xba')  \[${reset}\]"; # `$` (and reset color)
export PS1;
