#!/bin/bash

say_good_bye() {
    kill -s SIGTERM "$$" >/dev/null
    echo ""
    echo ""
    echo "Bye :)"
    exit 0
}


play() {
  ffplay -autoexit -nodisp "$@"
}

trap say_good_bye SIGINT SIGTERM

PLAYLIST=${1:-all}

CHILL_BASE_URL=https://s3.us-east-2.amazonaws.com/lofi.co/lofi.co/tracks/chill/chill_
# Playlist in google sheets!
SHEET_PLAYLIST_URL="https://sheets.googleapis.com/v4/spreadsheets/1LHdX1CrJQct6f6t1Cx8IxvtdLUjwd5kG0yPH9R0saRY/values/'tracce%20custom'!A2:F1000?key=AIzaSyCo3Wls8gIK0QuoUW3LlO4tbZD6DSxqe6g"
TRACKS=()

for ((i=1; i<=24; i++))
do
  TRACKS+=("$CHILL_BASE_URL$i.mp3")
done

if [ "$PLAYLIST" = "chill" ]; then
  while :
  do
    track=$((1 + RANDOM % ${#TRACKS[@]}))
    play "${TRACKS[$track]}"
  done
else

  for url in $(curl -s "$SHEET_PLAYLIST_URL" | jq -r .values[][3])
  do
    TRACKS+=("$url")
  done

  while :
  do
    track=$((1 + RANDOM % ${#TRACKS[@]}))
    curl -s "${TRACKS[$track]}" | play -
  done

fi
