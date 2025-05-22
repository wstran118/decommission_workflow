#!/bin/bash

source /configs/decommission.conf

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

#Shutdown server
log_message "Shopping $SERVER..."
docker stop "$SERVER" 2>> "$LOG_FILE"
if [ $? -eq 0 ]; then
    log_message "$SERVER shutdown successfully."
    echo "$SERVER shutdown successfully."
else
    log_message    "ERROR: Failed to stop $SERVER. Check $LOG_FILE for details."
    echo "ERROR: Failed to stop $SERVER. Check $LOG_FILE for details."    >&2
    exit 1
fi