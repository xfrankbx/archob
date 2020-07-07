#!/usr/bin/env bash

Options="Logout\n\
Restart\n\
Poweroff"
#Standby\n\
#Suspend\n\

picked=$(echo -e $Options | rofi \
  -dmenu \
  -theme mytheme \
  -location 3 \
  -width 5 \
  -lines 3 \
  -yoffset 20 \
  -xoffset -2 \
  -p "Action")

if [ "$picked" == "Logout" ]; then
  echo "logout selected"
  openbox --exit
  exit 0
elif [ "$picked" == "Restart" ]; then
  echo "restart selected"
  systemctl reboot
  exit 0
#elif [ "$picked" == "Standby" ]; then
#  echo "standby selected"
#  exit 0
#elif [ "$picked" == "Suspend" ]; then
#  echo "suspend selected"
#  exit 0
elif [ "$picked" == "Poweroff" ]; then
  echo "poweroff selected"
  systemctl poweroff
  exit 0
fi

