#!/bin/bash

#Source configuration
source /configs/decommision.conf

#Log function
log_message(){
    echo "($date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOG_FILE"
}

#Check for required tools
check_tool(){
    command -v "$1" >/dev/null 2>&1 || {
        log_message "ERROR: $1 is not installed."
        echo "ERROR: $1 is not installed. Please install it." >&2
        exit 1
    }
 }

log_message "Checking prerequisites..."
check_tool jq
check_tool tar
check_tool docker
check_tool ssh

#Check if backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR" || {
    log_message "ERROR: Failed to create backup directory $BACKUP_DIR"
    echo "ERROR: Failed to create backup directory $BACKUP_DIR" >&2 
    exit 1
     }
fi

#Check if log directory exists
LOG_DIR=$(dirname "$LOG_FILE")
if [ ! -d "$LOG_FILE" ]; then
    mkdir -p "$LOG_DIR" || {
        log_message "ERROR: Failed to create log directory $LOG_DIR"
        echo  "ERROR: Failed to create log directory $LOG_DIR" >&2 
        exit 1
      }
fi

log_message "Prerequisistes check passed."
echo "Prerequisites check passed.