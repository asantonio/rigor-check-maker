#!/bin/sh

while getopts n:s: flag
do
    case "${flag}" in
        n) name_of_check=${OPTARG};;
        s) site_address=${OPTARG};;
    esac
done
echo "Name: $name_of_check";
echo "URL: $site_address";
echo
echo "Creating real browser check..."

rvmcurl() {
  local url
  url="https://monitoring-api.rigor.com/v2/${1#/}"
  shift || return # function should fail if we weren't passed at least one argument
  curl -sS -XPOST "${rvm_curl_args[@]}" "$url" "$@" 
}

rvm_curl_args=(
  -H 'content-type:application/json' 
  -H 'API-KEY:<API_KEY>' 
)

#see locations.txt file for enums for the different real browser locations
data=$(jq -n --arg name_of_check "$name_of_check" --arg site_address "$site_address" '
{
    "name": $name_of_check,
    "tags": [
        "<MY-TAG1>","<MY-TAG2>"
    ],
    
    "frequency": 5,
    "round_robin": true,
    "auto_retry": false,
    "enabled": true,
    "locations": [
        5,6,21,38    
    ],
    
    "response_time_monitor_milliseconds": "5000",
    "http_request_headers": {
        "Content-Type": "text/html"
    },
    
    "notifications": {
        "sms": false,
        "email": false,
        "call": false,

        "notify_after_failure_count": 1,
        "notify_on_location_failure": false,

        "user_agent": "Mozilla/5.0 (X11; Linux x86_64; Rigor) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36",
        "auto_update_user_agent": false,
        "viewport": {
        "height": 768,
        "width": 1366
        },
        "muted": true
    },

    "browser": {
        "type": "chrome"
    },
  
    "enforce_ssl_validation": true,
    "url": $site_address,

    "threshold_monitors": [
        {
        "matcher": "rigor.com/example",
        "metric_name": "dom_load_time",
        "comparison_type": "less_than",
        "value": 3000
        }
    ],
  
    "connection": {
        "upload_bandwidth": 5000,
        "download_bandwidth": 20000,
        "latency": 28,
        "packet_loss": 0
    },

    "wait_for_full_metrics": true
}')

check=$(rvmcurl checks/real_browsers/ -d "$data")
echo $check
echo
echo $check  | jq '.links | "real browser check = \(.self_html)"'
echo $check  | jq '.links | "shareable link = \(.self_html)"'