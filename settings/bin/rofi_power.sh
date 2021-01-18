#!/usr/bin/env bash

Options="Lock\n\
Logout\n\
Standby\n\
Hibernate\n\
Restart\n\
Poweroff"

picked=$(echo -e $Options | rofi \
  -dmenu \
  -theme mytheme \
  -location 3 \
  -width 5 \
  -lines 6 \
  -yoffset 20 \
  -xoffset -2 \
  -p "Action")

if [ "$picked" == "Lock" ]; then
  ~/bin/lock.sh
elif [ "$picked" == "Logout" ]; then
  openbox --exit
elif [ "$picked" == "Standby" ]; then
  systemctl suspend
elif [ "$picked" == "Hibernate" ]; then
  systemctl hibernate
elif [ "$picked" == "Restart" ]; then
  systemctl reboot
elif [ "$picked" == "Poweroff" ]; then
  systemctl poweroff
fi
