# Simulated Data Center Decommissioning Workflow

This project simulates decommissioning a server rack in a data center, automating data backup, service shutdown, server shutdown, and inventory updates using Bash scripts on Ubuntu 22.04 with Docker. It demonstrates Linux administration, automation, troubleshooting, and documentation skills for Data Center Operations (DCO) Technician roles.

## Prerequisites
- Ubuntu 22.04 (or similar Linux distribution)
- Tools: Docker, jq, tar

## Installation
1. Clone the repository:
````
git clone 
cd decommission
````
2. Setup virtual servers:
````
./setup.sh
````

## Usage
Run the decommissioning workflow:
````
./scripts/decommission.sh
````

### Outputs:
- Updated: inventory/server_inventory.json
- Report: inventory/decommission_report.csv
- Logs: logs/decommission.log

## Features
- Backup: Archives /data/app_data to /backups.
- Service Shutdown: Stop services (e.g., nginx, mysql).
- Server Shutdown: Stop docker containers.
- Inventory Management: Update server status and generates CSV reports.
- Troubleshooting: Logs errors (e.g, insufficient disk space).
