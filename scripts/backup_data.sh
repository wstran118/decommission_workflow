#!/bin/bash

#source configuration
source /configs/decommission.conf

#log function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

SERVER=$1
if [ -z "$SERVER" ]; then
    log_message "ERROR: No server specified for backup."
    echo "ERROR: No server specified." >&2
    exit 1
fi

#Get data path from inventory
DATA_PATH=$(jq -r ".[] | select(.server_id==\"$SERVER\") |.data_path" "$INVENTORY_FILE")
if [ -z "$DATA_PATH" ]; then
    log_message "ERROR: No data path found for $SERVER."
    echo  "ERROR: No data path found for $SERVER." >&2
    exit 1
fi

#Check disk space
DISK_SPACE=$(df -m "$BACKUP_DIR" | tail -1 | awk '{print $4}')
if [ "$DISK_SPACE" -lt "$MIN_DISK_SPACE_MB" ]; then
    log_message  "ERROR: Not enough disk space ($DISK_SPACE MB) to backup on $SERVER."
    echo   "ERROR: Not enough disk space ($DISK_SPACE MB) to backup $SERVER."  >&2
    exit 1
fi

#Perform backup
BACKUP_FILE="$BACKUP_DIR/$SERVER-$(DATE +%Y%m%d).tar.gz"
log_message "Starting backup for $SERVER to $BACKUP_FILE..."
tar -czf "$BACKUP_FILE" "$DATA_PATH" 2>> "$LOG_FILE"
if [ $? -eq 0 ]; then
    log_message "Backup for $SERVER completed successfully."
    echo "Backup for $SERVER completed successfully."
else
    log_message  "ERROR: Backup for $SERVER failed. Check $LOG_FILE for details."
    echo "Backupfor  $SERVER failed. Check $LOG_FILE for details."  >&2
fi