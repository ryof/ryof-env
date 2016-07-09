@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
choco install -y atom
rem fails somehow
rem choco install -y cygwin
choco install -y eclipse
choco install -y googlechrome
choco install -y jdk8
choco install -y skype
choco install -y slack
choco install -y transmission-qt
choco install -y visualstudiocode
choco install -y vlc
choco install -y awscli
choco install -y git