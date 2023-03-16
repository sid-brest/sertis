#!/bin/bash

# Set the URL of the web page to check
url="https://medic-service.by/BrestGDP3/ticketGet/?room_id=1573"

# Set the text to search for in the web page content
text_to_search="нет доступных талонов"

# Fetch the content of the web page and search for the text
if curl -s "$url" | grep -q "$text_to_search"; then
  echo "The web page contains the text '$text_to_search'"
else
  echo "The web page does not contain the text '$text_to_search'"
fi

# Use watch command to run the script every 1 minute
# watch -n 60 bash checkpage.sh