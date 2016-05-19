# set dotfiles
if [ ! -e ~/.ryof-env ]; then
	xcode-select --install
	git clone https://github.com/ryof/ryof-env ~/.ryof-env
	ln -s ~/.ryof-env/.vimrc ~/.vimrc
	ln -s ~/.ryof-env/.bash_profile ~/.bash_profile
fi

# install homebrew if not
if type brew > /dev/null 2>&1; then
	echo "brew exists"
else
	sudo mkdir -p /opt/brew
	sudo chown -R $(id -u):$(id -g) /opt
	cd /opt/brew
	curl -L https://github.com/Homebrew/homebrew/tarball/master | tar xz --strip 1 -C .
	# avoiding permission-denied for some casks
	sudo ln -s /opt/brew /usr/local/bin/brew
	sudo chown -R $(id -u):$(id -g) /usr/local/
fi
brew update

# install brew packages
brew tap homebrew/binary
brew tap cloudfoundry/tap

# install OSX applications
brew cask install appcleaner
brew cask install atom
brew cask install eclipse-platform
brew cask install firefox
brew cask install google-chrome
brew cask install google-japanese-ime
brew cask install iterm2
brew cask install java
brew cask install kitematic
brew cask install skype
brew cask install shiftit
brew cask install sourcetree
brew cask install virtualbox
brew cask install visual-studio-code
brew cask install vlc

# install Quick Look plugins (cf. https://github.com/sindresorhus/quick-look-plugins)
brew cask install elcolorcode
brew cask install qlstephen
brew cask install qlmarkdown
brew cask install quicklook-json
brew cask install qlprettypatch
brew cask install quicklook-csv
brew cask install betterzipql
brew cask install qlimagesize
brew cask install webpquicklook
brew cask install suspicious-package

# install brew packages
brew install android-sdk && \
	expect -c "
	    set timeout -1
	    spawn android update sdk --no-ui --filter platform-tools

	    expect {
	        \"Do you accept the license\" {
	            send \"y\n\"
	            exp_continue
	        }
	        Downloading {
	            exp_continue
	        }
	        Installing {
	            exp_continue
	        }
	    }
	"
# FIXME: brew install awk
brew install awscli
brew install cf-cli
brew install dos2unix
# FIXME: brew install gcc
brew install git
brew install go
brew install gradle
brew install iftop
brew install jad
brew install jq
brew install lua && \
	brew install vim --with-lua && \
	curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh && \
	mkdir -p ~/.vim/dein.vim && \
	sh ./installer.sh ~/.vim/dein.vim && \
	rm installer.sh
brew install nkf
brew install nmap
brew install node
brew install pyenv
brew install rbenv
# FIXME: brew install source-highlight
brew install sshrc
brew install tree
# FIXME: brew install wget

source ~/.bash_profile

# change OSX settings
defaults write com.apple.finder QLEnableTextSelection -bool true
defaults write com.apple.screencapture type jpg
defaults write com.apple.screencapture “disable-shadow” -bool yes
defaults write com.apple.screencapture name ss
defaults write com.apple.screencapture location ~/ss/
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
# TODO: Change system language to English
# TODO: Add some applications to LoginItem
# TODO: Disable 'select next iput source' shortcut
# TODO: Change Spotlight keyboard-shortcut to option+command+space
# Switch key CapsLock <> Control
defaults -currentHost write -g 'com.apple.keyboard.modifiermapping.1452-566-0' -array '<dict><key>HIDKeyboardModifierMappingDst</key><integer>2</integer><key>HIDKeyboardModifierMappingSrc</key><integer>0</integer></dict>'
# TODO: Some Dock settings

killall Finder
killall Dock
killall SystemUIServer
