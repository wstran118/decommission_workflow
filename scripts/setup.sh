#!/bin/bash

source /configs/decommission.conf

#log function
log_message() {
    echo "$(date '+%Y-%m%H:%M:%S') $1" >> "$LOG_FILE"
}

log_message "Setting up virtual environment..."

#create backup and log directories
mkdir -p "$BACKUP_DIR" "$LOG_DIR"

#Start docker containers
SERVERS=("server01","server02","server03")
for SERVER in "${SERVERS[@]}"; do
    log_message "Starting container for $SERVER..."
    docker run -d --name "$SERVER" -v /data/app_data:/data/app_data ubuntu:22.04 tail -f /dev/null
    if [ $? -eq 0 ]; then
        log_message "Container started for $SERVER."
        docker exec "$SERVER" mkdir -p /data/app_data
        docker exec "$SERVER" bash -c "echo 'Sample data' > /data/app_data/sample.txt"
        docker exec "$SERVER" apt-get update && apt-get install -y nginx mysql-server
    else
        log_message   "ERROR: Failed to start container for $SERVER. Check $LOG_FILE for details."
        echo  "ERROR: Failed to start container for $SERVER. Check $LOG_FILE for details." >&2
        exit 1
done

log_message "Setup completed."
echo "Setup completed. Servers are running."