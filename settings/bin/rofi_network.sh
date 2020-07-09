#!/usr/bin/env bash


g_type=
g_typicon=
g_ip4=
g_lines=

function error () {
  echo "$1"
  exit $2
}

function core () {

  device=$1

  dev="dev_${device[0]}"
  declare -A $dev

  while IFS= read line
  do
    key=`echo $line | cut -d':' -f1 | cut -d'.' -f2`
    value=`echo $line | cut -d':' -f2- | sed -e 's/ //g'`
    eval $dev+="([\"$key\"]=\"$value\")"
  done < <(nmcli device show ${device[0]} | egrep "DEVICE|TYPE|HWADDR|STATE|ADDRESS|GATEWAY" | \
  sed -e 's/GENERAL.//' | \
  sed -e 's/IP4./IP4/' | \
  sed -e 's/IP6./IP6/')

  ip4="$dev[IP4ADDRESS[1]]"
  type="$dev[TYPE]"

  g_ip4=${!ip4}
  g_type=${!type}

  case ${!type} in
    ethernet)
      g_typeicon=""
      ;;
    wifi)
      g_typeicon=""
      ;;
  esac
#  echo "${g_typeicon} - ${g_ip4}"

}

# Get list of connected devices
device=(`nmcli device | grep connected | awk '{print $1}'`)

case $1 in
  showall)
    for i in $(seq ${#device[@]})
    do
      let  i-=1
      core ${device[$i]}
#      g_lines+="$(core ${device[$i]})\n"
      g_lines+="${g_typeicon} - ${g_type} - ${g_ip4}\n"
    done

    picked=$(echo -e $g_lines | rofi \
      -dmenu \
      -theme mytheme \
      -location 3 \
      -width 25 \
      -lines ${#device[@]} \
      -yoffset 20 \
      -xoffset -100 \
      -p "IP(s)")

    ;;
  *)
    if [ ${#device[@]} -eq 0 ]; then
      error "Error: No connected interfaces" 2
    elif [ ${#device[@]} -ge 1 ]; then
      core ${device[0]}
      echo "%{T5}${g_typeicon}%{T1} ${g_ip4}%{T-}"
    fi
    ;;
esac





exit
#  Options="${g_type}  |  ${g_ip4}\n\
#  \n\
#  \n\
#  \n\
#  "



# =========================================================================================== #





