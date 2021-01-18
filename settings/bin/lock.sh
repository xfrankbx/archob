#!/bin/sh

B='#00000000'  # blank
C='#000000'  # clear ish
D='#0B98c6'  # default
T='#a6a6a6'  # text
W='#000000'  # wrong
V='#00bbbb'  # verifying

i3lock \
--insidevercolor=$C   \
--ringvercolor=$D     \
\
--insidewrongcolor=$C \
--ringwrongcolor=$D   \
\
--insidecolor=$B      \
--ringcolor=$D        \
--linecolor=$B        \
--separatorcolor=$D   \
\
--verifcolor=$T        \
--wrongcolor=$T        \
--timecolor=$T        \
--datecolor=$T        \
--layoutcolor=$T      \
--keyhlcolor=$T       \
--bshlcolor=$W        \
\
--screen 1            \
--blur 5              \
--clock               \
--indicator           \
--timestr="%H:%M:%S"  \
--datestr="%A, %m %Y" \
--keylayout 2         \

