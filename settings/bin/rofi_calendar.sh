#! /bin/sh

BLOCK_BUTTON=1

today=$(date +%e)

DATEFTM="${DATEFTM:-+%a. %d. %b. %Y}"
SHORTFMT="${SHORTFMT:-+%d.%m.%Y}"
LABEL="${LABEL:-}"
blockdate=$(date "$DATEFTM")
shortblockdate=$(date "$SHORTFMT")

year=$(date '+%Y')
month=$(date '+%m')
case "$BLOCK_BUTTON" in
  1|2)
    date=$(date '+%A, %d. %B');;
  3)
    (( month == 12 )) && month=1 && year=$((year + 1)) || month=$((month + 1))
    date=$(cal $month $year | sed -n '1s/^  *//;1s/  *$//p')
esac
case "$BLOCK_BUTTON" in
  1|2|3)
#export TERM=xterm
  cal $month $year | cat -v | sed -e 's/_^H//g' \
    | sed -e "s|${today} |<span background=\"#7f1e31\">${today} </span>|" \
    | tail -n +2 | head -n +6 \
    | rofi \
      -dmenu \
      -markup-rows \
      -theme mytheme \
      -location 3 \
      -width 13 \
      -lines 6 \
      -yoffset 20 \
      -xoffset -45 \
      -no-custom \
      -p "$date"
esac

