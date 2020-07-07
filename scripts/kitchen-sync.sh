#!/usr/bin/env bash
## Rough script, needs a lot of cleaning and organization after I have everything in it I want.


# Stop script if we hit an error
set -e

orgpwd=`pwd`

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
  echo "################################################################"
  echo "###   trizen installed"
  echo "################################################################"
fi


echo "################################################################"
echo "###   Installing Xorg with fbdev"
echo "################################################################"

# This is the opensource driver for FrameBuffer Device"
software=(
xorg-server
xorg-apps
xorg-xinit
xorg-twm
xterm
xf86-video-fbdev
)

for name in ${software[@]}
do
  if pacman -Qi $name &> /dev/null; then
    echo "################################################################"
    echo "###   $name is already installed"
    echo "################################################################"
  else
    echo "####################################################"
    echo "###   installing: $name"
    echo "####################################################"
    trizen -S --noconfirm --needed $name
    echo "####################################################"
    echo "###   $name installed"
    echo "####################################################"
  fi
done
echo "################################################################"
echo "###   xorg installed"
echo "################################################################"


echo "################################################################"
echo "###   Installing core software"
echo "################################################################"

software=(
#*Compression
#arj
#cabextract
#file-roller
#sharutils
#unace
#unrar
unzip
#uudeview
#zip


*System-Info
neofetch
#archey3
#screenfetch
#inxi


#*Media
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


#*Screenshots
#gnome-screenshot
#scrot


*Programming-Languages
python3


*Xorg-Misc
#gnome-font-viewer
#galculator
#gnome-disk-utility
#gnome-system-monitor
#gparted
#variety
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
#compton
xcompmgr
dmenu
feh
gmrun
#lxappearance-obconf
lxrandr
obkey-git
#ob-autostart
#menumaker
#nitrogen
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
#redshift
#sane
#simple-scan
#simplescreenrecorder
thunar
tumbler
unclutter
rofi-git
community/yad
community/xdotool
community/jq
aur/polybar
gksu


*Fonts-Themes-icons-cursors
#awesome-terminal-fonts
#adobe-source-sans-pro-fonts
#community/terminus-font
#community/ttf-ubuntu-font-family
#ttf-ms-fonts
#urxvt-resize-font-git
#noto-fonts
#ttf-roboto
#font-manager-git
#aur/siji-git
#aur/ttf-material-design-icons-webfont #Fails to install
#community/powerline-fonts
#community/ttf-inconsolata
#extra/ttf-dejavu
#ttf-font-awesome
breeze-snow-cursor-theme

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
    if pacman -Qi $name &> /dev/null; then
      echo "################################################################"
      echo "###   $name is already installed"
      echo "################################################################"
    else
      echo "####################################################"
      echo "###   installing: $name"
      echo "####################################################"
      trizen -S --noconfirm --needed $name
      echo "####################################################"
      echo "###   $name installed"
      echo "####################################################"
    fi
  fi
done

echo "################################################################"
echo "###   core software installed"
echo "################################################################"


# Enable and start services installed above
sudo systemctl enable vnstat
sudo systemctl enable NetworkManager.service
sudo systemctl enable lightdm.service


[ -d "$HOME/bin" ] || mkdir -p "$HOME/bin"
[ -d "$HOME/.icons" ] || mkdir -p "$HOME/.icons"
[ -d "$HOME/.local/share/fonts" ] || mkdir -p "$HOME/.local/share/fonts"
[ -d "$HOME/.local/share/plank/themes" ] || mkdir -p "$HOME/.local/share/plank/themes"
[ -d "$HOME/.config/openbox" ] || mkdir -p "$HOME/.config/openbox"
[ -d "$HOME/.config/plank/dock1/launchers" ] || mkdir -p "$HOME/.config/plank/dock1/launchers"
[ -d "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml" ] || mkdir -p "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml"
[ -d "$HOME/.config/termite" ] || mkdir -p "$HOME/.config/termite"
[ -d "$HOME/.config/rofi" ] || mkdir -p "$HOME/.config/rofi"
[ -d "$HOME/.config/polybar" ] || mkdir -p "$HOME/.config/polybar"


### Icons/Themes
[ -d /tmp/sardi ] && rm -rf /tmp/sardi
wget -O /tmp/sardi.zip "https://sourceforge.net/projects/sardi/files/latest/download?source=files"
mkdir /tmp/sardi
cd ~/.icons
unzip /tmp/sardi.zip
rm /tmp/sardi.zip
[ -d /tmp/sardi ] && rm -rf /tmp/sardi

[ -d /tmp/Sardi-Extra ] && rm -rf /tmp/Sardi-Extra
git clone https://github.com/erikdubois/Sardi-Extra /tmp/Sardi-Extra
find /tmp/Sardi-Extra -maxdepth 1 -type f -exec rm -rf '{}' \;
cp -rf /tmp/Sardi-Extra/* ~/.icons/
[ -d /tmp/Sardi-Extra ] && rm -rf /tmp/Sardi-Extra

[ -d /tmp/Surfn ] && rm -rf /tmp/Surfn
git clone https://github.com/erikdubois/Surfn /tmp/Surfn
find /tmp/Surfn -maxdepth 1 -type f -exec rm -rf '{}' \;
cp -rf /tmp/Surfn/* ~/.icons/
[ -d /tmp/Surfn ] && rm -rf /tmp/Surfn

[ -d /tmp/Plank-Themes ] && rm -rf /tmp/Plank-Themes
git clone https://github.com/erikdubois/Plank-Themes /tmp/Plank-Themes
find /tmp/Plank-Themes -maxdepth 1 -type f -exec rm -rf '{}' \;
cp -r /tmp/Plank-Themes/* ~/.local/share/plank/themes/
[ -d /tmp/Plank-Themes ] && rm -rf /tmp/Plank-Themes


##########################################################################################


mkdir -p ~/tmp/fonts
cd ~/tmp/fonts
wget "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Bold/complete/Iosevka%20Term%20Bold%20Nerd%20Font%20Complete.ttf" -O Iosevka_Term_Bold_Nerd_Font_Complete.ttf
#wget "https://github.com/stark/siji/raw/master/pcf/siji.pcf" -O siji.pcf
wget "https://downloads.sourceforge.net/project/termsyn/termsyn-1.8.7.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Ftermsyn%2Ffiles%2Ftermsyn-1.8.7.tar.gz%2Fdownload&ts=1561132280" -O termsyn-1.8.7.tar.gz
wget http://unifoundry.com/pub/unifont/unifont-12.1.02/font-builds/unifont-12.1.02.ttf -O unifont-12.1.02.ttf
wget http://dl.dafont.com/dl/?f=pizzadude_bullets -O pizzadude_bullets.zip
wget http://dl.dafont.com/dl/?f=openlogos -O openlogos.zip
wget https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip -O Hack-v3.003-ttf.zip

tar -zxf termsyn-1.8.7.tar.gz
unzip Hack-v3.003-ttf.zip
unzip openlogos.zip
unzip pizzadude_bullets.zip
chown frank.frank * -R
#mv siji.pcf ~/.local/share/fonts/
mv Iosevka_Term_Bold_Nerd_Font_Complete.ttf ~/.local/share/fonts/
mv termsyn-1.8.7/*.pcf termsyn-1.8.7/*.psfu ~/.local/share/fonts/
mv *.ttf ~/.local/share/fonts/
mv ttf/Hack* ~/.local/share/fonts/
rmdir ttf
rm -f pizzadudedotdk.txt
rm -rf termsyn-1.8.7
fc-cache -v


#####################################


cd $orgpwd

cp ../settings/bin/* ~/bin

cp ../settings/.config/openbox/autostart ~/.config/openbox/

cp ../settings/.config/plank/dock1/launchers/* ~/.config/plank/dock1/launchers/
cat ../settings/dconf/plank.dconf | dconf load /net/launchpad/plank/docks/dock1/

cp ../settings/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/

cp ../settings/.config/termite/config ~/.config/termite/

cp ../settings/.config/rofi/* $HOME/.config/rofi
cp ../settings/.config/polybar/* $HOME/.config/polybar


echo "################################################################"
echo "###   All done, please reboot"
echo "################################################################"
