#!/bin/bash
LOG_FILE="$(dirname "$0")/logs/operations.log"

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

echo "===== System Information ====="
echo "Hostname:          $(hostname)"
echo "Current User:      $(whoami)"
echo "Date/Time:         $(date)"
echo "Operating System:  $(uname -o)"
echo "Kernel Version:    $(uname -r)"
echo "Uptime:            $(uptime -p)"
echo "Working Directory: $(pwd)"
echo ""
echo "----- CPU Info -----"
lscpu | grep -E "Model name|CPU\(s\):|Architecture"
echo ""
echo "----- Memory Info -----"
free -h

log_action "system-info.sh executed by $(whoami)"

