#!/usr/bin/env bash
#    ___
#   / _ \___ _    _____ ____
#  / ___/ _ \ |/|/ / -_) __/
# /_/   \___/__,__/\__/_/
#
if [[ "$1" == "exit" ]]; then
	echo ":: Exit"
	hyprshutdown -t "Exiting..." --post-cmd 'hyprctl dispatch "hl.dsp.exit()"'
fi

if [[ "$1" == "lock" ]]; then
	echo ":: Lock"
	sleep 0.5
	hyprlock
fi

if [[ "$1" == "reboot" ]]; then
	echo ":: Reboot"
	hyprshutdown -t 'Restarting...' --post-cmd 'reboot'
fi

if [[ "$1" == "shutdown" ]]; then
	echo ":: Shutdown"
	hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0'
fi

if [[ "$1" == "suspend" ]]; then
	echo ":: Suspend"
	sleep 0.5
	systemctl suspend
fi

if [[ "$1" == "hibernate" ]]; then
	echo ":: Hibernate"
	sleep 1
	systemctl hibernate
fi
