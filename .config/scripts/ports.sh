#!/bin/bash

# ==============================
# ports - clean listening ports viewer
# Author: you
# ==============================

# Colors
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
YELLOW="\e[33m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

clear

echo -e "${BOLD}${CYAN}"
echo "┌──────────────────────────────────────────────┐"
echo "│              Listening Ports                │"
echo "└──────────────────────────────────────────────┘"
echo -e "${RESET}"

printf "${BOLD}%-8s %-8s %-22s %-10s %s${RESET}\n" \
"PROTO" "PORT" "PROCESS" "PID" "ADDRESS"

echo "────────────────────────────────────────────────────────────────────"

ss -tulpnH 2>/dev/null | while read -r line; do

    proto=$(echo "$line" | awk '{print $1}')

    addr=$(echo "$line" | awk '{print $5}')

    proc=$(echo "$line" | grep -oP 'users:\(\(".*?",pid=\K[0-9]+' | head -1)

    pname=$(echo "$line" | grep -oP 'users:\(\("\K[^"]+' | head -1)

    port=$(echo "$addr" | awk -F':' '{print $NF}')

    address=$(echo "$addr" | sed "s/:$port//")

    [[ -z "$pname" ]] && pname="unknown"
    [[ -z "$proc" ]] && proc="-"

    # protocol color
    if [[ "$proto" == tcp* ]]; then
        proto_color="${GREEN}$proto${RESET}"
    else
        proto_color="${BLUE}$proto${RESET}"
    fi

    # dangerous/common ports highlight
    case "$port" in
        22)   port_color="${YELLOW}$port (SSH)${RESET}" ;;
        80)   port_color="${GREEN}$port (HTTP)${RESET}" ;;
        443)  port_color="${GREEN}$port (HTTPS)${RESET}" ;;
        3306) port_color="${RED}$port (MySQL)${RESET}" ;;
        *)    port_color="$port" ;;
    esac

    printf "%-17b %-18b %-22s %-10s %s\n" \
    "$proto_color" \
    "$port_color" \
    "$pname" \
    "$proc" \
    "$address"

done
