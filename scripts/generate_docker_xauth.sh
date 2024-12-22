#!/bin/sh
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f /tmp/.docker.genesis.$USER.xauth nmerge -
