#!/bin/bash
battery_status (){

	STATUS=$(cat /sys/class/power_supply/BAT0/status)

	if [[ $STATUS = "Discharging" ]]; then
		CHARGE=$(cat /sys/class/power_supply/BAT0/capacity)

		if [ $CHARGE -le 25 ]; then
			notify-send --urgency=CRITICAL "Battery Low" "Level: ${CHARGE}%"
		fi
	fi
}

while true
do
	battery_status
	sleep 180
done
