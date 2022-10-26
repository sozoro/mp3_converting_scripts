#!/usr/bin/env bash

set -eu

out="$2"
error_log="$3"

function mp3_converter () {
  metadata=$(ffmpeg -i "$1" -f ffmetadata -y - 2>/dev/null)

  track=$(echo "$metadata" | sed -n -E 's/^track=(.*)$/\1/p')
  title=$(echo "$metadata" | sed -n -E 's/^title=(.*)$/\1/p')
  track=$(echo "$track" | sed -e 's/\/.*$//' -e 's/^0*//')

  if [ -n "$track" ] && [ -n "$title" ]; then
    outDir="$out/$(dirname "$1")"
    mkdir -p "$outDir"
    outFile=$(printf '%03d' "$track"; echo "_$title.mp3" | sed 's/\//_/g')
    if [ ! -e "$outFile" ]; then
      if [ "${1##*.}" = "mp3" ]; then
        cp -n "$1" "$outDir/$outFile"
        chmod 644 "$outDir/$outFile"
      else
        ffmpeg -n -i "$1" "$outDir/$outFile"
      fi
    fi
  else
    echo "$1" >> "$error_log"
  fi
}

mp3_converter "$1" || echo "$1" >> "$error_log"
