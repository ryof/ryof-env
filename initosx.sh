# set dotfiles
if [ ! -e ~/.ryof-env ]; then
	xcode-select --install
	git clone https://github.com/ryof/ryof-env ~/.ryof-env
	ln -s ~/.ryof-env/.vimrc ~/.vimrc
	ln -s ~/.ryof-env/.bash_profile ~/.bash_profile
fi

# install google-cloud-sdk
export CLOUDSDK_CORE_DISABLE_PROMPTS=1 
curl https://sdk.cloud.google.com | bash
mv ${HOME}/.bash_profile.backup .ryof-env/.bash_profile

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
brew cask install qlcolorcode
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
brew install gawk
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

# install latest stable ruby
# FIXME: rbenv install $(rbenv install -l | grep -v - | tail -1) && rbenv rehash

# install latest stable python 2 and 3
pyenv install $(pyenv install -l | grep -v - | tr -d ' ' | grep '^2' | tail -1) && \
	pyenv install $(pyenv install -l | grep -v - | tr -d ' ' | grep '^3' | tail -1) && \
	pyenv rehash

# change OSX settings
defaults write com.apple.finder QLEnableTextSelection -bool true
defaults write com.apple.screencapture type jpg
defaults write com.apple.screencapture “disable-shadow” -bool yes
defaults write com.apple.screencapture name ss
defaults write com.apple.screencapture location ~/ss/
# fast input
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
# conventional scroll
defaults write -g com.apple.swipescrolldirection -bool false
# Change system language to English, and Japanese
defaults write -g AppleLanguages -array en ja
# Select Dictionaries
defaults write -g com.apple.DictionaryServices -dict-add "DCSActiveDictionaries" '("/Library/Dictionaries/Sanseido Super Daijirin.dictionary", "/Library/Dictionaries/Sanseido The WISDOM English-Japanese Japanese-English Dictionary.dictionary", "/System/Library/Frameworks/CoreServices.framework/Frameworks/DictionaryServices.framework/Resources/Wikipedia.wikipediadictionary", "/Library/Dictionaries/Oxford Thesaurus of English.dictionary", "/Library/Dictionaries/Oxford Dictionary of English.dictionary")'
# iODO: Add some applications to LoginItem
# Disable 'select next iput source' shortcut
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "<dict><key>enabled</key><false/></dict>"
# Change Spotlight keyboard-shortcut to option+command+space
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1572864</integer></array><key>type</key><string>standard</string></dict></dict>"
# Remap CapsLock key to Control
keyboardid=$(ioreg -n IOHIDKeyboard -r | grep -E 'VendorID"|ProductID' | awk '{ print $4 }' | paste -s -d'-\n' -)'-0'
defaults -currentHost write -g com.apple.keyboard.modifiermapping.${keyboardid} -array '<dict><key>HIDKeyboardModifierMappingDst</key></dict><integer>2</integer> <key>HIDKeyboardModifierMappingSrc</key><key>0</key>'

# Some Dock settings
# move Dock to left
defaults write com.apple.dock orientation left
# automatically hide dock
defaults write com.apple.dock autohide -bool true
# show no applications except Finder, Downloads, Trash and running ones
defaults write com.apple.dock persistent-apps -array
# size down Dock
defaults write com.apple.dock tilesize -int 25

# Some Finder settings
defaults write com.apple.finder CreateDesktop -bool false
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.finder ShowRecentTags -bool false
defaults write com.apple.finder SidebarDevicesSectionDisclosedState -bool true
defaults write com.apple.finder SidebarPlacesSectionDisclosedState -bool true
defaults write com.apple.finderSidebarSharedSectionDisclosedState -bool true
defaults write -g AppleShowAllExtensions -bool true
# TODO: cannot specify sidebar items?

# others
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
# Allow apps downloaded from anywhere
# FIXME: not working?
sudo defaults write /Library/Preferences/com.apple.security GKAutoRearm -bool NO
# Turn off Bluetooth
sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
# Enable Google Japanese Input
# FIXME: currently not working
# defaults write com.apple.HIToolbox AppleEnabledInputSources -array '<array><dict><key>Bundle Id</key><string>com.google.inputmethod.Japanese</string><key>InputSourceKind</key><string>Keyboard Input Method</string></dict><dict><key>Bundle Id</key><string>com.google.inputmethod.Japanese</string><key>Input Mode</key><string>com.apple.inputmethod.Japanese</string><key>InputSourceKind</key><string>Input Mode</string></dict><dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><string>252</string><key>KeyboardLayout Name</key><string>ABC</string></dict><dict><key>Bundle Id</key><string>com.apple.PressAndHold</string><key>InputSourceKind</key><string>Non Keyboard Input Method</string></dict></array>'

# reflect preference-changes
sudo killall cfprefsd
# set Google Chrome default browser
open -a "Google Chrome" --args --make-default-browser

killall Dock
killall SystemUIServer
killall Finder

echo -e "You better reboot this machine.. \xF0\x9f\xa4\x94"
