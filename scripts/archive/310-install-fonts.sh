#!/bin/bash
set -e

echo "################################################################"
echo "###   Installing fonts"
echo "################################################################"


fonts=(
# pacman
awesome-terminal-fonts
adobe-source-sans-pro-fonts
terminus-font
ttf-ubuntu-font-family
# trizen
font-manager-git
ttf-ms-fonts
urxvt-resize-font-git
)

for font in ${fonts[@]}
do
  if pacman -Qi $package &> /dev/null; then
    echo "################################################################"
    echo "###   $font is already installed"
    echo "################################################################"
  else
    echo "################################################################"
    echo "###   Installing $font"
    echo "################################################################"
    trizen -S --noconfirm --needed $font
done
