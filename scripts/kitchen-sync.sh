#!/usr/bin/env bash

# Stop script if we hit an error
set -e

echo "################################################################"
echo "###   Installing reflector"
echo "################################################################"

# installing refector to test wich servers are fastest
sudo pacman -S --noconfirm --needed reflector pacman-contrib

echo "################################################################"
echo "###   finding fastest servers be patient for the world"
echo "################################################################"

# finding the fastest archlinux servers
sudo reflector -l 100 -f 50 --sort rate --threads 5 --verbose --save /tmp/mirrorlist.new
rankmirrors -n 0 /tmp/mirrorlist.new > /tmp/mirrorlist
sudo cp /tmp/mirrorlist /etc/pacman.d

echo "################################################################"
echo "###   fastest servers saved"
echo "################################################################"

echo "################################################################"
echo "###   Updating to the latest versions"
echo "################################################################"

sudo pacman -Syyu --noconfirm --needed

echo "################################################################"
echo "###   Your system is now up to date"
echo "################################################################"


if pacman -Qi trizen &> /dev/null; then
  echo "################################################################"
  echo "###   trizen is already installed"
  echo "################################################################"
else
  echo "################################################################"
  echo "###   Installing trizen"
  echo "################################################################"
  sudo pacman -S --noconfirm --needed git fakeroot binutils
  git clone https://aur.archlinux.org/trizen-git.git /tmp/trizen-git
  cd /tmp/trizen-git
  makepkg --noconfirm --needed -si
fi

echo "################################################################"
echo "###   trizen installed"
echo "################################################################"

echo "################################################################"
echo "###   Installing Xorg with fbdev"
echo "################################################################"

# This is the opensource driver for FrameBuffer Device"
sudo pacman -S xorg-server xorg-apps xorg-xinit xorg-twm xterm --noconfirm --needed
sudo pacman -S xf86-video-fbdev --noconfirm --needed

echo "################################################################"
echo "###   xorg installed"
echo "################################################################"

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

*Networking
networkmanager
network-manager-applet

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
nemo
nemo-share
nemo-fileroller
exo
gsimplecal
lightdm
lightdm-gtk-greeter
notify-osd
numlockx
obconf
openbox
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
oblogout
obmenu


*zsh
zsh
zsh-completions
zsh-syntax-highlighting
command-not-found

*Uncategorized-software
#darktable
dconf-editor
gpick
meld
mlocate
polkit-gnome
redshift
#sane
#simple-scan
#simplescreenrecorder
thunar
tumbler
unclutter

*Themes-icons-cursors
ttf-font-awesome
breeze-snow-cursor-theme

*Fonts
# pacman
awesome-terminal-fonts
adobe-source-sans-pro-fonts
terminus-font
ttf-ubuntu-font-family
# trizen
font-manager-git
ttf-ms-fonts
urxvt-resize-font-git
noto-fonts
ttf-roboto


)

for name in ${software[@]}
do
  if [[ "$name" =~ "*" ]];
  then
    name=`echo "$name" | sed -e 's/\*//g'`
    echo "################################################################"
    echo "###   * installing group $name *"
    echo "################################################################"
    sleep 2
  else
    echo "####################################################"
    echo "###   installing: $name"
    trizen -S --noconfirm --needed $name
    echo "####################################################"
    echo "###   $name installed"
    echo "####################################################"
  fi
done


# Enable and start services installed above
sudo systemctl enable vnstat
sudo systemctl start vnstat
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service
sudo systemctl enable lightdm.service

echo "################################################################"
echo "###   Installing core software - aur"
echo "################################################################"

trizen -S --noconfirm --needed gksu inxi

echo "################################################################"
echo "###   core software installed"
echo "################################################################"



### Icons/Fonts/Themes

# cleaning tmp
[ -d /tmp/Sardi-Extra ] && rm -rf /tmp/Sardi-Extra
[ -d /tmp/Surfn ] && rm -rf /tmp/Surfn
[ -d /tmp/Plank-Themes ] && rm -rf /tmp/Plank-Themes


# if there is no hidden folder then make one
[ -d "$HOME/.icons" ] || mkdir -p "$HOME/.icons"
[ -d "$HOME/.local/share/plank" ] || mkdir -p "$HOME/.local/share/plank"
[ -d "$HOME/.local/share/plank/themes" ] || mkdir -p "$HOME/.local/share/plank/themes"

wget -O /tmp/sardi.zip "https://sourceforge.net/projects/sardi/files/latest/download?source=files"
mkdir /tmp/sardi
cd ~/.icons
unzip /tmp/sardi.zip
rm /tmp/sardi.zip

git clone https://github.com/erikdubois/Sardi-Extra /tmp/Sardi-Extra
find /tmp/Sardi-Extra -maxdepth 1 -type f -exec rm -rf '{}' \;
cp -rf /tmp/Sardi-Extra/* ~/.icons/
[ -d /tmp/Sardi-Extra ] && rm -rf /tmp/Sardi-Extra

git clone https://github.com/erikdubois/Surfn /tmp/Surfn
find /tmp/Surfn -maxdepth 1 -type f -exec rm -rf '{}' \;
cp -rf /tmp/Surfn/* ~/.icons/
[ -d /tmp/Surfn ] && rm -rf /tmp/Surfn

git clone https://github.com/erikdubois/Plank-Themes /tmp/Plank-Themes
find /tmp/Plank-Themes -maxdepth 1 -type f -exec rm -rf '{}' \;
cp -r /tmp/Plank-Themes/* ~/.local/share/plank/themes/
[ -d /tmp/Plank-Themes ] && rm -rf /tmp/Plank-Themes


mkdir -p ~/.config/openbox
mkdir -p ~/.config/plank/dock1/launchers
mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml

cp ../settings/.config/openbox/autostart ~/.config/openbox/

cp ../settings/.config/plank/dock1/launchers/* ~/.config/plank/dock1/launchers/
cat ../settings/dconf/plank.dconf | dconf load /net/launchpad/plank/docks/dock1/

cp ../settings/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/
