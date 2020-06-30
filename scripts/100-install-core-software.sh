#!/bin/bash
set -e
##################################################################################################################
# Written to be used on 64 bits computers
# Author        :       Erik Dubois
# Website       :       http://www.erikdubois.be
##################################################################################################################
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

echo "################################################################"
echo "###   Installing core software - standard"
echo "################################################################"

software=(
*Compression
#arj
#cabextract
#file-roller
#sharutils
#unace
#unrar
#unzip
#uudeview
#zip

*System-Info
archey3
screenfetch

*Media
#clementine
#mpv
#openshot
#shotwell
#vlc
#smplayer
#ristretto

*Internet
#evolution
filezilla
firefox
#geary
#hexchat
#transmission-cli
#transmission-gtk

*Graphics-Editing
#gimp
#inkscape

*System-Utilities
dmidecode
glances
#hddtemp
htop
lm_sensors
lsb-release
net-tools
notify-osd
numlockx
vnstat
termite

*User-Utilities
bash-completion
baobab
bleachbit
catfish
curl
git
sysstat
wget

*Screenshots
#gnome-screenshot
#scrot

*Programming-Languages
python3

*Xorg-Misc
gnome-font-viewer
galculator
gnome-disk-utility
gnome-system-monitor
#gparted
variety
plank
#conky
grsync
evince

*Uncategorized-software
darktable
dconf-editor
gpick
meld mlocate
polkit-gnome
redshift
#sane
#simple-scan
#simplescreenrecorder
thunar
tumbler
unclutter
)

for name in ${software[@]}
do
  if [[ "$name" =~ "*" ]];
  then
    name=`echo "$name" | sed -e 's/\*//g'`
    echo "* installing group $name *"
  else
    echo "installing: $name"
    trizen -S --noconfirm --needed $name
  fi
done


exit

##### write if statement checking for installation of vnstat
sudo systemctl enable vnstat
sudo systemctl start vnstat

echo "################################################################"
echo "###   Installing core software - aur"
echo "################################################################"

trizen -S --noconfirm --needed gksu inxi

echo "################################################################"
echo "###   core software installed"
echo "################################################################"
