#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

mkdir -p "$HOME/Downloads/VPN"

xhost +local:docker
docker build -t firefox-wireguard -f $SCRIPT_DIR/Dockerfile $SCRIPT_DIR && docker run --rm \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /run/user/$(id -u)/pulse/native:/pulse/socket \
    -v "$SCRIPT_DIR/config/distribution":/usr/lib/firefox-esr/distribution \
    -v "$SCRIPT_DIR/config/syspref.js":/etc/firefox-esr/syspref.js \
    -v "$HOME/Downloads/VPN":/home/user/Downloads \
    --user $(id -u):$(id -g) \
    --shm-size 2g \
    -e DISPLAY="$DISPLAY" --net=container:/wireguard firefox-wireguard "$@"
