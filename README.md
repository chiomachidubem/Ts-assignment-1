# Assignment 1 — Linux, Bash & Networking Toolkit

A collection of Bash scripts for basic Linux diagnostics: system information,
disk usage checking, and network connectivity checks.

## Requirements

- A Linux environment (tested on WSL2 / Ubuntu)
- Bash

## Setup

Clone this repository and make the scripts executable:

```bash
git clone <this-repo-url>
cd assignment-1
chmod +x *.sh
```

## Usage

### system-info.sh

Displays hostname, current user, date/time, OS, kernel version, uptime,
CPU info, memory info, and working directory.

```bash
./system-info.sh
```

### disk-check.sh

Checks disk usage against a threshold percentage.

```bash
./disk-check.sh <threshold> [path]
```

- `threshold`: integer from 1–100 (required)
- `path`: filesystem path to check (default: `/`)
- Exit 0: usage is below threshold
- Exit 1: usage has reached/exceeded threshold
- Exit 2: invalid input

Example:
```bash
./disk-check.sh 80 /home
```

### network-check.sh

Resolves a host, checks connectivity, shows network interfaces, and
optionally checks TCP port connectivity.

```bash
./network-check.sh <hostname-or-ip> [port]
```

- `port`: optional, must be 1–65535 if supplied
- Exit 2: invalid input
- Exit 1: host unreachable or port closed

Example:
```bash
./network-check.sh google.com 443
```

## Testing

Run the grading script to check all requirements:

```bash
./grade.sh
```

## Logging

All three scripts append timestamped entries to `logs/operations.log`
describing what was run and the result.

## Assumptions

- Scripts assume a standard Linux environment with `df`, `free`, `lscpu`,
  `ping`, `getent`, and `ip` available.
- No external dependencies beyond standard coreutils/iproute2 tools.
