#!/bin/bash

# Set the URL of the web page to check
url="https://medic-service.by/BrestGDP3/ticketGet/?room_id=1573"

# Set the text to search for in the web page content
text_to_search="нет доступных талонов"

# Set the maximum time to wait for the web page to load in seconds
timeout_seconds=10

# Fetch the content of the web page and search for the text
if curl -s --max-time "$timeout_seconds" "$url" | grep -q "$text_to_search"; then
  echo "The web page contains the text '$text_to_search'"
else
  echo "The web page does not contain the text '$text_to_search'"
fi

# Use watch command to run the script every 1 minute
# watch -n 60 bash checkpage.sh