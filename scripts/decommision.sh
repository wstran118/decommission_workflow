#!/bin/bash

source configs/decomission.conf

#log function
log_message() {
    echo "$(date +%Y-%m-%d_%H:%M:%S): $1" >> $LOG_FILE
}

#Check prerequisites
./script/check_prerequisites.sh

#List of servers to decommission
SERVERS=("server01","server02","sever03")
log_message "Starting decommissioning workflow..."

#Initialize report file
echo "server_id,date,status" > "$REPORT_FILE"

for SERVER in "${ERVERS[@]}"; do
    log_message "Decommissioning $SERVER..."
    echo "Decommissioning $SERVER..."

    #backup data
    ./scripts/backup_data.sh "$SERVER"
    if [ $? -ne 0 ]; then
       log_message "ERROR: Decommissioning aborted. Failed to backup $SERVER."
        echo "ERROR: Decommissioning aborted. Failed to backup $SERVER." >&2
        exit 1
    fi

    #stop services
    ./scripts/stop_services.sh "$SERVER"
    if [ $? -ne 0 ]; then
       log_message "ERROR: Decommissioning aborted. Failed to stop services on $SERVER."
        echo "ERROR: Decommissioning aborted. Failed to stop services on $SERVER."  >&2
        exit 1
    fi

    #shut down server
    ./scripts/shutdown_server.sh "$SERVER"
    if [ $? -ne 0 ]; then
        log_message "ERROR: Decommissioning aborted. Failed to shutdown $SERVER."
        echo "ERROR: Decommissioning aborted. Failed to shutdown $SERVER."   >&2
        exit 1
    fi

    #update inventory
    ./scripts/update_inventory.sh "$SERVER"
    if [ $? -ne 0 ]; then
       log_message "ERROR: Decommissioning aborted. Failed to update inventory for $SERVER."
        echo "ERROR: Decommissioning aborted. Failed to update inventory for $SERVER."   >&2
        exit 1
    fi

    log_message "$SERVER decommissioned successfully."
    echo "$SERVER decommissioned successfully."
done

log_message "Decommissioning workflow completed."
echo "Decommissioning workflow completed. Report generated in $REPORT_FILE."
