#!/usr/bin/env bash


bn="/sys/class/leds/smc\:\:kbd_backlight/brightness"
cbn=$(cat $bn)

case $1 in
  status)
    python  -c "print(int(($cbn / 255) * 100))"
    ;;
  up)
    let cbn+=25
    if [ $cbn -ge 225 ];then
      echo 250 | sudo tee -a $bn >/dev/null
    else
      echo $cbn | sudo tee -a $bn >/dev/null
    fi
    ;;
  down)
    let cbn-=25
    if [ $cbn -le 0 ];then
      echo 0 | sudo tee -a $bn >/dev/null
    else
      echo $cbn | sudo tee -a $bn >/dev/null
    fi
    ;;
  [0-9]|[0-9][0-9]|100)
    python -c "print(int(($1 * .0254) * 101))" | sudo tee -a $bn >/dev/null
    ;;
esac


exit;


