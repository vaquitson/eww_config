#!/bin/bash

EWW_PATH="/home/narval/r_repos/eww/target/release/eww"
NOTCH_DAEMON_PATH="/home/narval/.config/eww/notch_daemon/notch_daemon.py"

# open top bar
$EWW_PATH daemon
$EWW_PATH open top_bar
$EWW_PATH open notch
$NOTCH_DAEMON_PATH

