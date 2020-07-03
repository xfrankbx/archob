#!/usr/bin/env bash

Options="Logout\n\
Restart\n\
Standby\n\
Suspend\n\
Poweroff"

picked=$(echo -e $Options | rofi \
  -dmenu \
  -theme mytheme \
  -location 3 \
  -width 5 \
  -lines 5 \
  -yoffset 20 \
  -xoffset -2 \
  -p "Action")

if [ "$picked" == "Logout" ]; then
  echo "logout selected"
  exit 0
elif [ "$picked" == "Restart" ]; then
  echo "restart selected"
  init 6
  exit 0
elif [ "$picked" == "Standby" ]; then
  echo "standby selected"
  exit 0
elif [ "$picked" == "Suspend" ]; then
  echo "suspend selected"
  exit 0
elif [ "$picked" == "Poweroff" ]; then
  echo "poweroff selected"
  init 0
  exit 0
fi

