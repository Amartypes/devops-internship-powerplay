#!/usr/bin/env bash

LOG_FILE="/var/log/system_report.log"

{
  echo "===== System Report: $(date '+%Y-%m-%d %H:%M:%S') ====="
  echo "Uptime:"
  uptime -p
  echo

  echo "CPU Usage (%):"
  top -bn1 | awk '/Cpu\(s\)/ {printf "%.2f\n", 100 - $8}'
  echo

  echo "Memory Usage (%):"
  free | awk '/Mem:/ { printf("%.2f\n", $3/$2 * 100.0) }'
  echo

  echo "Disk Usage (%):"
  df -h / | awk 'NR==2 {gsub("%","",$5); print $5}'
  echo

  echo "Top 3 Processes by CPU:"
  ps -eo pid,comm,%cpu --sort=-%cpu | head -n 4
  echo
  echo
} >> "$LOG_FILE"
