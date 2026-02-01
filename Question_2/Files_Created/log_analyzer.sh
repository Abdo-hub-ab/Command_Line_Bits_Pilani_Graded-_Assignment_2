#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
  echo "Error: Please provide exactly ONE argument (log file path)."
  echo "Usage: ./log_analyzer.sh <logfile>"
  exit 1
fi

logfile="$1"

if [ ! -e "$logfile" ]; then
  echo "Error: Log file does not exist: $logfile"
  exit 1
fi

if [ ! -f "$logfile" ]; then
  echo "Error: Path is not a regular file: $logfile"
  exit 1
fi

if [ ! -r "$logfile" ]; then
  echo "Error: Log file is not readable: $logfile"
  exit 1
fi

total_entries=$(wc -l < "$logfile")
info_count=$(awk '$3=="INFO"{c++} END{print c+0}' "$logfile")
warn_count=$(awk '$3=="WARNING"{c++} END{print c+0}' "$logfile")
error_count=$(awk '$3=="ERROR"{c++} END{print c+0}' "$logfile")

most_recent_error=$(awk '$3=="ERROR"{last=$0} END{print (last?last:"No ERROR entries found")}' "$logfile")

report_date=$(date +%Y-%m-%d)
report_file="logsummary_${report_date}.txt"

{
  echo "Log Summary Report - $report_date"
  echo "Log file: $logfile"
  echo "---------------------------------"
  echo "Total log entries: $total_entries"
  echo "INFO count:    $info_count"
  echo "WARNING count: $warn_count"
  echo "ERROR count:   $error_count"
  echo "---------------------------------"
  echo "Most recent ERROR entry:"
  echo "$most_recent_error"
} > "$report_file"

echo "Total log entries: $total_entries"
echo "INFO: $info_count"
echo "WARNING: $warn_count"
echo "ERROR: $error_count"
echo "Most recent ERROR entry:"
echo "$most_recent_error"
echo "Report generated: $report_file"
