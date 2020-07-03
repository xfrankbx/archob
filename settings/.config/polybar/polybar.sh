#!/bin/bash

# Colors
Color01="FFFFFF" # White
Color02="181818"  # Dark Grey
#Color02="888888"  # Grey
Color03="7f1e31"  # Red
Color04="0000FF"  # Blue

# Panel Settings
PanelColorFG="F#FF${Color01}"
PanelColorBG="B#FF${Color02}"

declare -A icon
icon[Power]=""
icon[NetLan]=""
icon[NetWifi]=""
icon[divider]="※"
icon[clock]=""
icon[calendar]=""
icon[menu]=""

declare -A arrow
arrow[left]=""
arrow[right]=""


export LeftSection1="%{T3}%{F#${Color01}}%{B#${Color02}}%{A:~/bin/rofi_progmenu.sh:} ${icon[menu]} %{A-}%{F#${Color02}}%{B#${Color03}}${arrow[right]}%{F#${Color01}}%{T-}"
export LeftSection2="%{T3}%{F#${Color03}}%{B#${Color02}}${arrow[right]}%{F-}%{T-}"

export RightSection1="%{F#${Color02}}%{B#${Color03}}${arrow[left]}%{F-}%{B-}"
#export RightSection1="%{F#${Color02}}%{B#${Color03}}${arrow[left]}%{F-}%{B-}%{A:~/bin/rofi_power.sh:}  ${icon[Power]}  %{A-}"
export RightSection2="%{F#${Color03}}%{B#${Color02}} ${arrow[left]}%{F#${Color01}}%{B#${Color03}}"
#export RightSection3="%{r} %{F#${Color01}}%{B#${Color02}} $(Network)"

polybar -c ~/.config/polybar/config.ini main -r

