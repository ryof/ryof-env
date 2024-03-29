#!/bin/bash -eux
# set dotfiles
if [ ! "${CI}" ] && [ ! -e ~/.ryof-env ]; then
  if git version > /dev/null 2>&1; then
    git clone https://github.com/ryof/ryof-env ~/.ryof-env
    git clone git://github.com/rupa/z ~/.ryof-env/z
    ln -s ~/.ryof-env/.vimrc ~/.vimrc
    ln -s ~/.ryof-env/.tmux.conf ~/.tmux.conf
    ln -sf ~/.ryof-env/.bash_profile ~/.bash_profile
    ln -sf ~/.bash_profile ~/.bashrc
    # mkdir -p ~/.config
    # ln -s ~/.ryof-env/fish ~/.config/fish
    ln -s ~/.ryof-env/.gitignore_global ~/.gitignore_global
    ln -sf ~/.ryof-env/.gitconfig ~/.gitconfig
    mkdir -p ~/.gnupg
    ln -s ~/.ryof-env/gpg-agent.conf ~/.gnupg/gpg-agent.conf
  else
    echo 'After installing some tools, execute this script again.'
    exit 0
  fi
fi

# get AppleID informations
# unable to be automated because of this issue: https://github.com/mas-cli/mas/issues/164
if [ ! "${CI}" ]; then
  read -rp "AppleID: " apple_user_name
  echo
fi

# install tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# install google-cloud-sdk
if [ ! -e ~/google-cloud-sdk ]; then
  # FIXME: this env var doesn't seem to work
  export CLOUDSDK_CORE_DISABLE_PROMPTS=1
  curl https://sdk.cloud.google.com | bash &> /dev/null
fi

curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

# uninstall pre-installed formulae (Github Actions only)
if [ "${CI}" ]; then
  #shellcheck disable=SC2046
  brew uninstall --force $(brew list)
fi

# install homebrew if not
if type brew > /dev/null 2>&1; then
  echo "brew exists"
else
  sudo chown -R "$(id -u)":"$(id -g)" /usr/local/
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
brew update

# install OSX applications
export HOMEBREW_CASK_OPTS='--appdir=/Applications'
brew install appcleaner --cask
brew install atom --cask
brew install aws-vault --cask
brew install authy --cask
brew install datagrip --cask
brew install docker --cask
brew install eclipse-platform --cask
brew install firefox --cask
brew install google-chrome --cask
brew install google-japanese-ime --cask
brew install hma-pro-vpn --cask
brew install intellij-idea-ce --cask
brew install iterm2 --cask
brew install kindle --cask
brew install kitematic --cask
brew install pycharm --cask
brew install skype --cask
brew install shiftit --cask
brew install sourcetree --cask
brew install transmission --cask
brew install visual-studio-code --cask
brew install vlc --cask
brew install xquartz --cask

# install Quick Look plugins (cf. https://github.com/sindresorhus/quick-look-plugins)
brew install qlcolorcode --cask
brew install qlstephen --cask
brew install qlmarkdown --cask
brew install quicklook-json --cask
brew install qlprettypatch --cask
brew install quicklook-csv --cask
brew install qlimagesize --cask
brew install webpquicklook --cask
brew install suspicious-package --cask

# install brew packages
brew install android-sdk
brew install arp-scan
brew install bash && \
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells && \
  if [ ! "${CI}" ]; then chsh -s /usr/local/bin/bash; fi
brew install bash-completion
brew install colordiff
brew install coreutils
brew install dos2unix
brew install fping
brew install gawk
brew install gcc
brew install git
brew install gnu-sed
brew install gnupg
brew install go
brew install gpg2
brew install gradle
brew install iftop
brew install imagemagick
brew install jq
brew install lua
brew install mas
brew install mysql-client
brew install nkf
brew install nmap
brew install nodebrew && \
  mkdir -p ~/.nodebrew/src && \
  nodebrew install-binary latest && \
  nodebrew use latest
brew install openvpn
brew install peco
brew install pinentry-mac
brew install pyenv
brew install rbenv
brew install rename
brew install scala && \
  brew install sbt
brew install shellcheck
brew install source-highlight
brew install telnet
brew install tfenv
brew install tmux && \
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && \
  tmux source ~/.tmux.conf
brew install tree
brew install vim && \
  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh && \
  mkdir -p ~/.vim/dein.vim && \
  sh ./installer.sh ~/.vim/dein.vim && \
  rm installer.sh
brew install watch
brew install wget

# install completions
brew install gem-completion
brew install maven-completion
brew install ruby-completion

# shellcheck disable=SC1091
source "${HOME}"/.bash_profile

# install store applications
# unable to be automated because of this issue: https://github.com/mas-cli/mas/issues/164
if [ ! "${CI}" ]; then
  mas signin --dialog "${apple_user_name}"
  for id in $(mas list | cut -d' ' -f1); do
    mas install "${id}"
  done
fi

# Agree to the Xcode license
if [ ! "${CI}" ]; then sudo xcrun cc; fi

# install latest stable ruby
ruby_latest=$(rbenv install -l | grep -v - | tail -1)
rbenv install "${ruby_latest}" && \
  rbenv global "${ruby_latest}" && \
  rbenv rehash

# install latest stable python 2 and 3
python2_latest=$(pyenv install -l | grep -v - | tr -d ' ' | grep '^2' | tail -1)
python3_latest=$(pyenv install -l | grep -v - | tr -d ' ' | grep '^3' | tail -1)
pyenv install "${python2_latest}" && \
  pyenv install "${python3_latest}" && \
  pyenv global system "${python2_latest}" "${python3_latest}" && \
  pyenv rehash

echo "pinentry-program /usr/local/bin/pinentry-mac" >>~/.gnupg/gpg-agent.conf
""
# change OSX settings
defaults write com.apple.finder QLEnableTextSelection -bool true
defaults write com.apple.screencapture type jpg
defaults write com.apple.screencapture disable-shadow -bool yes
defaults write com.apple.screencapture name ss
defaults write com.apple.screencapture location ~/ss/
# fast input
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
# conventional scroll
defaults write -g com.apple.swipescrolldirection -bool false
# Change system language to English, and Japanese
defaults write -g AppleLanguages -array en ja
defaults write -g AppleLocale -string "en_JP"
# Select Dictionaries
defaults write -g com.apple.DictionaryServices -dict-add "DCSActiveDictionaries" '("/Library/Dictionaries/Sanseido Super Daijirin.dictionary", "/Library/Dictionaries/Sanseido The WISDOM English-Japanese Japanese-English Dictionary.dictionary", "/System/Library/Frameworks/CoreServices.framework/Frameworks/DictionaryServices.framework/Resources/Wikipedia.wikipediadictionary", "/Library/Dictionaries/Oxford Thesaurus of English.dictionary", "/Library/Dictionaries/Oxford Dictionary of English.dictionary")'
# TODO: Add some applications to LoginItem
# Disable 'select next iput source' shortcut
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "<dict><key>enabled</key><false/></dict>"
# Change 'Select the previous input source' to command+space
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>"
# Change Spotlight keyboard-shortcut to option+command+space
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1572864</integer></array><key>type</key><string>standard</string></dict></dict>"
# Disable 'Show Finder search window' shortcut
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "<dict><key>enabled</key><false/></dict>"
# Change shortcut for focusing on next window
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 9 "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>96</integer><integer>50</integer><integer>1572864</integer></array><key>type</key><string>standard</string></dict></dict>"
# Remap CapsLock key to Control
keyboardid=$(ioreg -n IOHIDKeyboard -r | grep -E 'VendorID"|ProductID' | awk '{ print $4 }' | paste -s -d'-\n' -)'-0'
defaults -currentHost write -g com.apple.keyboard.modifiermapping."${keyboardid}" -array '<dict><key>HIDKeyboardModifierMappingDst</key></dict><integer>2</integer> <key>HIDKeyboardModifierMappingSrc</key><key>0</key>'

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
