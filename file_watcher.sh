#!/bin/bash

# file_watcher.sh - Automated file renamer and logger
WATCH_DIR="${1:-.}"
LOG_FILE="file_mod_log.txt"

echo "Monitoring directory: $WATCH_DIR"
echo "Logs stored in: $LOG_FILE"
echo "Press Ctrl+C to stop."

touch "$LOG_FILE"

sanitize_filename() {
    local name="$1"
    local sanitized=$(echo "$name" | tr ' ' '_' | tr -cd '[:alnum:]_.-' | sed 's/-\+/-/g' | sed 's/_\+/_/g')
    echo "$sanitized"
}

add_date_prefix() {
    local fname="$1"
    if [[ ! "$fname" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}_ ]]; then
        echo "$(date '+%Y-%m-%d')_$fname"
    else
        echo "$fname"
    fi
}

log_event() {
    local file="$1"
    local event="$2"
    local detail="$3"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo -e "\n### File: $file" >> "$LOG_FILE"
    echo "Date: $timestamp" >> "$LOG_FILE"
    echo "Event: $event" >> "$LOG_FILE"
    [[ -n "$detail" ]] && echo "Details: $detail" >> "$LOG_FILE"
    echo "----------------------------------------" >> "$LOG_FILE"
}

track_duration() {
    local file="$1"
    local start_mod=$(stat -c %Y "$file" 2>/dev/null || echo 0)
    sleep 2
    local end_mod=$(stat -c %Y "$file" 2>/dev/null || echo 0)
    echo $((end_mod - start_mod))
}

inotifywait -m -r -e create -e modify -e moved_to --format '%e %w%f' "$WATCH_DIR" | while read event fullpath; do
    filename=$(basename "$fullpath")
    dir=$(dirname "$fullpath")

    sanitized=$(sanitize_filename "$filename")
    prefixed=$(add_date_prefix "$sanitized")

    if [[ "$filename" != "$prefixed" ]]; then
        mv "$fullpath" "$dir/$prefixed"
        log_event "$prefixed" "Renamed" "Old name: $filename → New name: $prefixed"
        fullpath="$dir/$prefixed"
    fi

    if [[ "$event" == "MODIFY" || "$event" == "CLOSE_WRITE" ]]; then
        duration=$(track_duration "$fullpath")
        log_event "$(basename "$fullpath")" "Modified" "Active editing duration: ${duration}s"
    fi

    if [[ "$event" == "CREATE" ]]; then
        log_event "$(basename "$fullpath")" "Created" "File added to directory"
    fi
done
