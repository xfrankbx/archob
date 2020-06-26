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

# install awesome font for conky status bar
sh install-awesome-font-v1.sh

# Sardi-extra icons
sh icons-sardi-extra-v4.sh

# Sardi icons
sh icons-sardi-v3.sh

# Surfn icons
sh icons-surfn-v4.sh

# Arc theme
sh install-arc-gtk-theme-v1.sh

# Plank themes
sh plank-themes-v3.sh

# Cursor theme
sh install-breeze-cursor-theme-v1.sh

echo "################################################################"
echo "#############  eye candy software  installed   #################"
echo "################################################################"

