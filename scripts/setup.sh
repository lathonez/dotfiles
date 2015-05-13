#! /bin/bash

#
# Script to set up from scratch but should be able to be run repeatedly
#

# alphabetical list of apps to install
apps="docker.io feh git gnome-panel google-chrome-stable python python-pip scrot tcl rxvt-unicode vim vlc xmonad"

# shouldn't be run as root else all the links will be owned by root!
if [ `whoami` = "root" ]; then
	echo "Don't run this as root please"
	exit
fi

dpkg -s google-chrome-stable 2&> /dev/null
chrome_installed=$?

# add chrome to sources
#if [ $chrome_installed -eq 1 ]; then
#	echo "Adding chrome to sources.."
#	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
#	sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
#fi

echo "Updating system.."
#sudo apt-get -y update
#sudo apt-get -y upgrade

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
rm -f ~/.Xresources       && ln -s ~/utils/xmonad/Xresources ~/.Xresources
rm -f ~/.Xdefaults        && ln -s ~/utils/xmonad/Xdefaults  ~/.Xdefaults
rm -f ~/.xmonad/xmonad.hs && ln -s ~/utils/xmonad/xmonad.hs  ~/.xmonad/xmonad.hs
rm -f ~/.xmonad/xmobarrc  && ln -s ~/utils/xmonad/xmobarrc   ~/.xmonad/xmobarrc

# recompile xomand
xmonad --recompile
