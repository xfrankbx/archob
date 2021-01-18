#!/usr/bin/env bash


bn="/sys/class/backlight/gmux_backlight/brightness"
cbn=$(cat $bn)


case $1 in
  status)
    python  -c "print(int((($cbn - 5000)/ 75000) * 100))"
    ;;
  up)
    let cbn+=5000
    if [ $cbn -ge 75000 ];then
      echo 75000 | sudo tee -a $bn >/dev/null
    else
      echo $cbn | sudo tee -a $bn >/dev/null
    fi
    ;;
  down)
    let cbn-=5000
    if [ $cbn -le 5000 ];then
      echo 5000 | sudo tee -a $bn >/dev/null
    else
      echo $cbn | sudo tee -a $bn >/dev/null
    fi
    ;;
  [0-9]|[0-9][0-9]|100)
    echo $(( ( $1 * 750 ) + 5000 )) | sudo tee -a $bn >/dev/null
    ;;
  *)
    echo "Usage: $0 (status|up|down|[0-100])"
    ;;
esac

