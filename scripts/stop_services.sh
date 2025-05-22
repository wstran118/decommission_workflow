#!/bin/bash

#source configuration
source /configs/decommission.conf

#log function
log_message(){
    echo "$(date  +'%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

SERVER=$1
if [ -z "$SERVER" ]; then
    log_message "ERROR: No server name provided."
    echo "ERROR: No server specified." >&2
    exit 1
fi

#Get services from inventory
SERVICES=$(jq -r ".[] | select (.services.id == \"$SERVER\") |.services[]" "$INVENTORY_FILE")
if [ -z "$SERVICES" ]; then
    log_message "WARNING: No services found for $SERVER."
    echo "WARNING: No services found for $SERVER." >&2
    exit 0

#Stop each service
for SERVICE in $SERVICES; do
    log_message "Stopping $SERVICE on $SERVER..."
    #replace with actual SSH in the environment
    docker exec "$SERVER" systemctl stop "$SERVICE" 2>> "$LOG_FILE"
    if [ $? -eq 0 ]; then
        log_message "$SERVICE stopped on $SERVER."
        echo "$SERVICE stopped on $SERVER."
    else
        log_message   "ERROR: Failed to stop $SERVICE on $SERVER. Check $LOG_FILE for details."
        echo "ERROR: Failed to stop $SERVICE on $SERVER. Check $LOG_FILE for details."   >&2
        exit 1
    fi
done