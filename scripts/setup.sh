#! /bin/bash

#
# Script to set up from scratch but should be able to be run repeatedly
#

# alphabetical list of apps to install
apps="docker.io git gnome-panel google-chrome-stable pip python scrot tcl rxvt-unicode vim vlc xmonad"

# add chrome to sources

dpkg -s google-chrome-stable 2&> /dev/null
chrome_installed=$?

if [ $chrome_installed -eq 1 ]; then
	echo "Adding chrome to sources.."
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
fi

echo "Updating system.."
sudo apt-get -y update
sudo apt-get -y upgrade

for app in $apps; do
	echo "Installing ${app}.."
	sudo apt-get -y install $app
done

# assumes that bitbucket key is all setup
if [ ! -d ~/utils ]; then
	echo "Cloning utils from bitbucket.."
	cd ~
	git clone git@bitbucket.org:lathonez/utils.git
fi

# setup symlinks (remove and redraw)
echo "Resetting symlinks"
# xmonad dir isn't created yet
mkdir -p ~/.xmonad
rm -f ~/.bashrc && ln -s ~/utils/bash/bash_core ~/.bashrc
rm -f ~/.vimrc  && ln -s ~/utils/vim/.vimrc ~/.vimrc
rm -f ~/.xmonad/Xresources && ln -s ~/utils/xmonad/Xresources ~/.xmonad/Xresources
rm -f ~/.xmonad/xmonad.hs  && ln -s ~/utils/xmonad/xmonad.hs  ~/.xmonad/xmonad.hs
rm -f ~/.xmonad/xmobarrc   && ln -s ~/utils/xmonad/xmobarrc   ~/.xmonad/xmobarrc

# recompile xomand
xmonad --recompile
rm -f ~/.xmonad/Xdefaults  && ln -s ~/utils/xmonad/Xdefaults  ~/.xmonad/Xdefaults
