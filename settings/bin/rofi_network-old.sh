#!/bin/bash

t=0

toggle() {
    t=$(((t + 1) % 3))
}

trap "toggle" USR1

runme() {
  while true; do
    if [ $t -eq 0 ]; then
      echo "  $(nmcli device show `nmcli -c no c | grep ethernet | awk '{print $4}'` | grep IP4.ADD | awk '{print $2}') "
    elif [ $t -eq 1 ]; then
      echo "  $(curl ifconfig.co 2>/dev/null) "
    elif [ $t -eq 2 ]; then
      echo "%{T5} %{T1}wifi "
    fi
    sleep 1 &
    wait
  done
}

key="$1"
case $key in
  -t)
    kill -USR1 $(ps aux | grep "/rofi_network.sh" | grep -v grep | awk '{print $2}') 2>/dev/null
  ;;
  *)
    runme
  ;;
esac


#connshead=$(nmcli -c no c | head -n 1)
#conns=$(nmcli -c no c | sed -e 1,1d)

#echo "$conns" | \
# rofi \
#    -dmenu \
#    -markup-rows \
#    -theme mytheme \
#    -width 40 \
#    -lines 6 \
#    -yoffset 20 \
#    -xoffset -45 \
#    -no-custom \
#    -p "$connshead"

