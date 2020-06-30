#!/bin/bash
set -e
##################################################################################################################
# Written to be used on 64 bits computers
# Author 	: 	Erik Dubois
# Website 	: 	http://www.erikdubois.be
##################################################################################################################
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################


echo "################################################################"
echo "###   distro specific software installed"
echo "################################################################"

#Fonts

## sudo pacman -S ttf-ubuntu-font-family --noconfirm --needed conflicts with ttf-google-fonts
## sudo pacman -S ttf-droid --noconfirm --noconfirm --needed  conflicts with ttf-google-fonts
## sudo pacman -S ttf-inconsolata --noconfirm --needed        conflicts with ttf-google-fonts
sudo pacman -S noto-fonts --noconfirm --needed
sudo pacman -S ttf-roboto --noconfirm --needed

#File manager

sudo pacman -S nemo nemo-share nemo-fileroller --noconfirm --needed

# extra extensions to compare files if needed install it
# packer -S nemo-compare

# openbox - pacman
sudo pacman -S exo --needed --noconfirm
sudo pacman -S gsimplecal --needed --noconfirm
sudo pacman -S lightdm lightdm-gtk-greeter --needed --noconfirm
sudo pacman -S notify-osd --needed --noconfirm
sudo pacman -S numlockx --needed --noconfirm
sudo pacman -S obconf --needed --noconfirm
#sudo pacman -S oblogout --needed --noconfirm
#sudo pacman -S obmenu --needed --noconfirm
sudo pacman -S openbox --needed --noconfirm

sh install-oblogout-v1.sh
sh install-obmenu-v1.sh


# openbox - AUR - alphabetically

software=(
compton
dmenu
feh
gmrun
#lxappearance-obconf
lxrandr
obkey-git
#ob-autostart
#menumaker
nitrogen
obmenu-generator
#openbox-arc-git
lxinput
openbox-themes
playerctl
#tint2
xfce4-clipman-plugin
xfce4-panel
xfce4-settings
xfconf

)


for package in ${software[@]}
do
  if [[ "$package" =~ "*" ]];
  then
    package=`echo "$package" | sed -e 's/\*//g'`
    echo "* installing group $package *"
  else
    if pacman -Qi $package &> /dev/null; then
      echo "################################################################"
      echo "###   $package is already installed"
      echo "################################################################"
    else
      echo "################################################################"
      echo "###   Installing $package"
      echo "################################################################"
      trizen -S --noconfirm --needed $package
    fi
  fi

  # Just checking if installation was successful
  if pacman -Qi $package &> /dev/null; then
    echo "################################################################"
    echo "###   $package has been installed"
    echo "################################################################"
  else
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "!!!   $package has NOT been installed"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  fi

done


echo "################################################################"
echo "###   Display manager being activated"
echo "################################################################"

sudo systemctl enable lightdm.service

echo "Reboot and select the proper desktop environment"
echo "with the gauge symbol or autologin."

echo "################################################################"
echo "###   distro specific software installed"
echo "################################################################"
