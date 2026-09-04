#!/bin/bash
LOG_FILE="$(dirname "$0")/logs/operations.log"

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

HOST=$1
PORT=$2

# Validate: host is required
if [ -z "$HOST" ]; then
    echo "Error: hostname or IP is required."
    echo "Usage: $0 <hostname-or-ip> [port]"
    exit 2
fi

echo "===== Network Check: $HOST ====="

# Resolve the host
echo "----- DNS Resolution -----"
RESOLVED=$(getent hosts "$HOST" | awk '{print $1}' | head -1)

if [ -z "$RESOLVED" ]; then
    echo "Error: could not resolve host '$HOST'."
    exit 1
else
    echo "Resolved address: $RESOLVED"
fi

# Basic connectivity check (ping)
echo ""
echo "----- Connectivity Check (ping) -----"
if ping -c 2 -W 2 "$HOST" > /dev/null 2>&1; then
    echo "Host $HOST is reachable via ping."
else
    echo "Host $HOST did not respond to ping (may still be reachable on specific ports)."
fi

# Network interface info
echo ""
echo "----- Network Interfaces -----"
ip -brief addr show

# Optional port check
if [ -n "$PORT" ]; then
    echo ""
    echo "----- Port Check: $PORT -----"

    if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
        echo "Error: port must be a number between 1 and 65535."
        exit 2
    fi

    if timeout 3 bash -c "cat < /dev/null > /dev/tcp/$HOST/$PORT" 2>/dev/null; then
        echo "Port $PORT is OPEN on $HOST."
    else
        echo "Port $PORT is CLOSED or unreachable on $HOST."
        exit 1
    fi
fi
log_action "network-check.sh run: host=$HOST port=${PORT:-none} resolved=$RESOLVED"

exit 0

