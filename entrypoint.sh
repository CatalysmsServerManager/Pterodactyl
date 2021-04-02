#!/bin/bash
cd /home/container

[ ! -d /home/container/redis ] && mkdir /home/container/redis
[ ! -d /home/container/logs ] && mkdir /home/container/logs

echo "Starting Redis"
redis-server --daemonize yes --dir /home/container/redis

# Replace Startup Variables
MODIFIED_STARTUP=$(echo -e "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')

echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
exec ${MODIFIED_STARTUP}