#!/bin/sh
# 0 -> |
# 1 -> /
# 2 -> |
# 3 -> \

stat=$(cat /home/narval/.config/eww/tmp/spinner.txt)

if [ "$stat" -eq 0 ]; then
  frame=1
  cur=" "

elif [ "$stat" -eq 1 ]; then
  frame=2
  cur="."

elif [ "$stat" -eq 2 ]; then
  frame=3
  cur=".."

elif [ "$stat" -eq 3 ]; then
  frame=0
  cur="..."
fi

echo $frame > /home/narval/.config/eww/tmp/spinner.txt
echo $cur

