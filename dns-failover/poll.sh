#!/bin/sh

while true; do 
    OUT=$(curl -sS localhost:8000)
    TS=$(date +%s)
    echo "[$TS] $OUT"
    sleep 1
done
