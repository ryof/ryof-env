# set dotfiles
if [ ! -e ~/.ryof-env ]; then
	if git version > /dev/null 2>&1; then
		git clone https://github.com/ryof/ryof-env ~/.ryof-env
		ln -s ~/.ryof-env/.vimrc ~/.vimrc
		ln -s ~/.ryof-env/.bash_profile ~/.bash_profile
		ln -s ~/.ryof-env/.gitignore ~/.gitignore_global
		git config --global core.excludesfile ~/.gitignore_global
	else
		echo 'After installing some tools, execute this script again.'
		exit 0
	fi
fi

# get AppleID informations
read -p "AppleID: " apple_user_name
echo
read -sp "AppleID password: " apple_password
echo

# install google-cloud-sdk
if [ ! -e ~/google-cloud-sdk ]; then
	export CLOUDSDK_CORE_DISABLE_PROMPTS=1 
	curl https://sdk.cloud.google.com | bash
	mv ${HOME}/.bash_profile.backup .ryof-env/.bash_profile
fi

# install homebrew if not
if type brew > /dev/null 2>&1; then
	echo "brew exists"
else
	sudo chown -R $(id -u):$(id -g) /usr/local/
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
brew update

# install brew packages
brew tap homebrew/binary
brew tap cloudfoundry/tap

# install OSX applications
export HOMEBREW_CASK_OPTS='--appdir=/Applications'
brew cask install appcleaner
brew cask install atom
brew cask install datagrip
brew cask install eclipse-platform
brew cask install firefox
brew cask install google-chrome
brew cask install google-japanese-ime
brew cask install iterm2
brew cask install java
brew cask install kindle
brew cask install kitematic
brew cask install pycharm
brew cask install skype
brew cask install shiftit
brew cask install sourcetree
brew cask install transmission
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
brew install arp-scan
brew install awscli
brew install cf-cli
brew install dos2unix
brew install gcc
brew install git
brew install go
brew install gradle
brew install iftop
brew install imagemagick
brew install jad
brew install jq
brew install lua && \
	brew install vim --with-lua && \
	curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh && \
	mkdir -p ~/.vim/dein.vim && \
	sh ./installer.sh ~/.vim/dein.vim && \
	rm installer.sh
brew install mas
brew install nkf
brew install nmap
brew install node
brew install pyenv
brew install rbenv
brew install scala
brew install source-highlight
brew install sshrc
brew install tree
<<<<<<< HEAD
brew install typesafe-activator
=======
brew install watch
>>>>>>> 165e510a788463390a12997781c5e585cca4e8d5
brew install wget

source ~/.bash_profile

# install store applications
mas signin ${apple_user_name} "${apple_password}" 
mas install 715768417 #Microsoft Remote Desktop
mas install 407963104 #Pixelmator
mas install 497799835 #Xcode
mas install 803453959 #Slack
mas install 409183694 #Keynote
mas install 492167985 #MenubarClock
mas install 425424353 #The Unarchiver
mas install 451444120 #Memory Clean

# install latest stable ruby
rbenv install $(rbenv install -l | grep -v - | tail -1) && rbenv rehash

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
# TODO: Add some applications to LoginItem
# Disable 'select next iput source' shortcut
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "<dict><key>enabled</key><false/></dict>"
# Change Spotlight keyboard-shortcut to option+command+space
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1572864</integer></array><key>type</key><string>standard</string></dict></dict>"
# Change shortcut for focusing on next window
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 9 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>96</integer><integer>50</integer><integer>1572864</integer></array><key>type</key><string>standard</string></dict></dict>"
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

# enable right-click on trackpad
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

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
