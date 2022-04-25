#!/bin/bash

generate_lang () {
  while read -r line
  do
    # consume header line
    if [ -z "$HEADER_DONE" ]; then
        HEADER_DONE=1
        continue
    fi

    ROOT=SOUND
    DELAY=3
    SUBDIR=$(echo -n "$line" | awk -F ';' '{print $1}')
    LANG=$3
    FILENAME=$(echo -n "$line" | awk -F ';' '{print $2}')
    TEXT=$(echo -n "$line" | awk -F ';' '{print $3}')

    if [ "$SUBDIR" != "" ]; then
      OUTDIR="$ROOT/$LANG/$SUBDIR"
    else
      OUTDIR="$ROOT/$LANG"
    fi

    [ ! -d "$OUTDIR" ]  && mkdir -p "$OUTDIR"

    if test -f "$OUTDIR/$FILENAME"; then
      echo "File '$OUTDIR/$FILENAME' already exists. Skipping."
    else
      echo "File '$OUTDIR/$FILENAME' does not exist. Creating..."
      spx synthesize --text \""$TEXT"\" --voice "$2" --audio output "$OUTDIR/$FILENAME" || break
      sleep $DELAY
    fi
  done < "$1"
}
