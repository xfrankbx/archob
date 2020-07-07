#!/usr/bin/env bash

function error () {
  echo "$1"
  exit $2
}


# Get list of connected devices
device=`nmcli device | grep connected | awk '{print $1}'`
#device=(`cat f | awk '{print $1}'`)
[ ${#device} == 0 ] && error "Error: No connected interfaces" 2

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

case ${!type} in
  ethernet)
    typeicon=""
    ;;
  wifi)
    typeicon=""
    ;;
esac

echo "%{T5}$typeicon%{T1} ${!ip4}%{T-}"
#echo "${!ip4}"


exit
# =========================================================================================== #
echo "DEBUG: ${#dev_ens18[@]}"
echo "DEBUG: ${!dev_ens18[*]}"
echo "DEBUG: ${dev_ens18[@]}"
# =========================================================================================== #


exit

# =========================================================================================== #

#ips=`nmcli device show ${ethdev} | grep -i address | awk '{print $2}'`
#echo -n "IP(s): "
#for ip in ${ips}
#do
#  echo -n "$ip | "
#done
#echo

#for line in `nmcli device show ${ethdev} | head -n 1`
#do
#  echo $line
#  echo $line | awk '{print $1}' | cut -d'.' -f2 | sed -e 's/://'
#  echo $line | awk '{FS="\n"; print $1}' | cut -d'.' -f2 | sed -e 's/://'
#done

# =========================================================================================== #

#eval $dev="(["foo1"]="bar1")"
#eval $dev+="(["foo2"]="bar2")"
#eval $dev+="(["foo3"]="bar3")"
#eval $dev+="(["foo4"]="bar4")"
# =========================================================================================== #


#nmcli device show ens18 | head -n 1 | cut -d'.' -f2 | cut -d':' -f1`

Options="   ${ip}\n\
\n\
\n\
\n\
"

picked=$(echo -e $Options | rofi \
  -dmenu \
  -theme mytheme \
  -location 3 \
  -width 25 \
  -lines 5 \
  -yoffset 20 \
  -xoffset -2 \
  -p "Action")


