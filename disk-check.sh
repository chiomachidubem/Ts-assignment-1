#!/bin/bash
LOG_FILE="$(dirname "$0")/logs/operations.log"

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# First argument = threshold, second argument = path (default "/")
THRESHOLD=$1
PATH_TO_CHECK=${2:-/}

# Validate: threshold must be provided
if [ -z "$THRESHOLD" ]; then
    echo "Error: threshold is required."
    echo "Usage: $0 <threshold> [path]"
    exit 2
fi
#Validate: threshold must be an integer
if ! [[ "$THRESHOLD" =~ ^[0-9]+$ ]]; then
    echo "Error: threshold must be an ineger."
    exit 2
fi

# Validate: threshold must be between 1 and 100
if [ "$THRESHOLD" -lt 1 ] || [ "$THRESHOLD" -gt 100 ]; then
    echo "Error: threshold must be between 1 and 100."
    exit 2
fi

# Validate: path must exist
if [ ! -e "$PATH_TO_CHECK" ]; then
    echo "Error: path '$PATH_TO_CHECK' does not exist."
    exit 2
fi

# Get disk usage percentage (strip the % sign)
USAGE=$(df --output=pcent "$PATH_TO_CHECK" | tail -1 | tr -dc '0-9')

echo "Disk usage for $PATH_TO_CHECK: ${USAGE}%"

log_action "disk-check.sh run: path=$PATH_TO_CHECK threshold=$THRESHOLD usage=${USAGE}%"

if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo "WARNING: usage ($USAGE%) has reached or exceeded threshold ($THRESHOLD%)."
    exit 1
else
    echo "OK: usage ($USAGE%) is below threshold ($THRESHOLD%)."
    exit 0
fi
