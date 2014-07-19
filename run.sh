#!/bin/bash

docker run -it --name="mediagoblin" \
    -p 6543:6543 \
    _vky/mediagoblin:latest
