#!/bin/bash

pid=$1

if [[ -z $pid ]]; then
    echo "[!] Usage: pid2ps <PID>"
    exit 1
fi

if [[ $pid =~ ^[0-9]+$ ]]; then
    if name=$(cat /proc/$pid/comm 2>/dev/null); then
        echo "$name"
    else
        echo "[!] No such process"
        exit 1
    fi
else
    echo "[!] Invalid PID"
    exit 1
fi
