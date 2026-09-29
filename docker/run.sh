#!/bin/bash
#
# Build and start the NOS3 desktop container.
# Open http://localhost:6080/vnc.html once it's up.
#

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BASE_DIR=$(cd "$SCRIPT_DIR/.." && pwd)

IMAGE=nos3-desktop
NAME=nos3-desktop

docker build -t $IMAGE "$SCRIPT_DIR" || exit 1

docker rm -f $NAME > /dev/null 2>&1

docker run -d --privileged \
    --name $NAME \
    --hostname nos3 \
    --shm-size=2g \
    -p 127.0.0.1:6080:6080 \
    -v "$BASE_DIR":/home/jstar/nos3 \
    -v nos3-docker:/var/lib/docker \
    -v nos3-home:/home/jstar/.nos3 \
    $IMAGE || exit 1

echo "Waiting for desktop..."
for i in $(seq 1 60); do
    docker logs $NAME 2>&1 | grep -q "desktop ready" && break
    sleep 1
done
docker logs $NAME 2>&1 | tail -5
