#!/bin/bash

service postgresql start
sudo -u postgres createuser root
sudo -u postgres createdb -E UNICODE -O root mediagoblin --template=template0
./bin/gmg dbupdate
./lazyserver.sh
