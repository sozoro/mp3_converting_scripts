#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p ffmpeg

set -eux

error_log="mp3_converter_R_error_log_$(date +'%x_%R:%S' ).txt"

out="MP3"

pushd "$1"
find . -type f -and \( -name '*\.mp3' -or -name '*\.m4a' \) \
  -exec ../mp3_converter.sh {} "../$out" "$error_log" \;
popd

if [ -e "$error_log" ]; then
  echo error occurred while processing >&2
  exit 1
fi
