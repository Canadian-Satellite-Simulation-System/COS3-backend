#!/bin/bash
#
# Find the NOS3 desktop container with `docker ps` and kill it.
# Usage: ./docker/stop.sh [name-or-image]   (default: nos3-desktop)
#

TARGET=${1:-nos3-desktop}

# Match running containers by name or by image
IDS=$( { docker ps -q --filter "name=^${TARGET}$"; docker ps -q --filter "ancestor=${TARGET}"; } | sort -u )

if [ -z "$IDS" ]; then
    echo "No running container found for '$TARGET'"
    exit 0
fi

for ID in $IDS; do
    echo "Killing $(docker ps --filter "id=$ID" --format '{{.ID}}  {{.Names}}  ({{.Image}})')"
    docker kill "$ID" > /dev/null
done

