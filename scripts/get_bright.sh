

get () {
  cur=$(cat /sys/class/backlight/*/brightness)
  max=$(cat /sys/class/backlight/*/max_brightness)
  brightness_percent=$(( 100 * cur / max ))
  echo "$brightness_percent"
}


if [[ "$1" == "get" ]]; then
  get
fi
