#!/bin/bash

# Function to determine Daylight Saving Time (DST) dates for Europe
# DST starts on the last Sunday of March and ends on the last Sunday of October.
get_eu_dst_dates() {
  local year=$1
  # DST Start: Last Sunday of March
  local march_last_day=$(date -d "$year-03-31" +%w)
  local start_offset=$(( (march_last_day - 0 + 7) % 7 ))
  local start_date=$(date -d "$year-03-31 - $start_offset days" "+%Y-%m-%d")

  # DST End: Last Sunday of October
  local oct_last_day=$(date -d "$year-10-31" +%w)
  local end_offset=$(( (oct_last_day - 0 + 7) % 7 ))
  local end_date=$(date -d "$year-10-31 - $end_offset days" "+%Y-%m-%d")

  echo "EU DST Start: $start_date"
  echo "EU DST End:   $end_date"
}

# Function to determine Daylight Saving Time (DST) dates for North America
# DST starts on the second Sunday of March and ends on the first Sunday of November.
get_na_dst_dates() {
  local year=$1
  # DST Start: Second Sunday of March
  local march_first_day=$(date -d "$year-03-01" +%w)
  local start_offset=$(( (0 - march_first_day + 7) % 7 ))
  local start_date=$(date -d "$year-03-01 + $((start_offset + 7)) days" "+%Y-%m-%d")

  # DST End: First Sunday of November
  local nov_first_day=$(date -d "$year-11-01" +%w)
  local end_offset=$(( (0 - nov_first_day + 7) % 7 ))
  local end_date=$(date -d "$year-11-01 + $end_offset days" "+%Y-%m-%d")

  echo "NA DST Start: $start_date"
  echo "NA DST End:   $end_date"
}

# --- Test Cases ---
echo "--- Testing for year 2024 ---"
get_eu_dst_dates 2024
get_na_dst_dates 2024
echo ""
echo "--- Testing for year 2025 ---"
get_eu_dst_dates 2025
get_na_dst_dates 2025
echo ""
echo "--- Testing for year 2026 ---"
get_eu_dst_dates 2026
get_na_dst_dates 2026
echo "--- Testing for year 2027 ---"
get_eu_dst_dates 2027
get_na_dst_dates 2027
