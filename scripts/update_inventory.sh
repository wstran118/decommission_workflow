#!/bin/bash

#source configuration
source /config/decommission.conf

#log function
log_message(){
    echo "$(date   +'%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

SERVER=$1
if [ -z "$SERVER" ]; then
    log_message "ERROR: No server name provided."
    echo "ERROR: No server specified." >&2
    exit 1
fi

#Update inventory
log_message "Updating inventory for $SERVER..."
jq "(.[] | select(.server_id == \"$SERVER\") | .status) = \"decommission\"" "$INVENTORY_FILE"
if [ $? -eq 0 ]; then
    mv temp.json "$$INVENTORY_FILE"
    log_message "Inventory updated for $SERVER."
    echo "Inventory updated for $SERVER."
else
    log_message  "ERROR: Failed to update inventory. Check $LOG_FILE for details."
    echo "ERROR: Failed to update inventory. Check $LOG_FILE for details."    >&2
    exit 1
fi

#Append to report
echo "$SERVER,$(date +%Y-%m%H:%M:%S),decommissioned" >> "$REPORT_FILE"
log_message "Added $SERVER to decommission report."