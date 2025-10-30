#!/bin/bash

while true; do
    ENERGY_NOW=$(cat /sys/class/power_supply/BAT0/energy_now 2>/dev/null || echo "0")
    POWER_NOW=$(cat /sys/class/power_supply/BAT0/power_now 2>/dev/null || echo "0")
    POWER_NOW=${POWER_NOW#-}
    ENERGY_FULL=$(cat /sys/class/power_supply/BAT0/energy_full 2>/dev/null || echo "0")
    STATUS=$(cat /sys/class/power_supply/BAT0/status)

    if [ "$POWER_NOW" -ne 0 ] && [ "$POWER_NOW" != "0" ]; then
        if [[ "$STATUS" == "Discharging" ]]; then
            HOURS_LEFT=$(( ENERGY_NOW / POWER_NOW ))
            MINS_LEFT=$(( (ENERGY_NOW * 60 / POWER_NOW) % 60 ))
            echo "${HOURS_LEFT}h ${MINS_LEFT}m remaining"
        elif [[ "$STATUS" == "Charging" ]]; then
            DIFF=$(( ENERGY_FULL - ENERGY_NOW ))
            HOURS_TO_FULL=$(( DIFF / POWER_NOW ))
            MINS_TO_FULL=$(( (DIFF * 60 / POWER_NOW) % 60 ))
            echo "${HOURS_TO_FULL}h ${MINS_TO_FULL}m to full"
        else
            echo "Battery Full"
        fi
    else
        echo "Calculating..."
    fi
    sleep 3
done
