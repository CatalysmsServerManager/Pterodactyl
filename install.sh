#!/bin/bash
set -ex

useradd -d /home/container -m container -s /bin/bash

[ ! -d /mnt/server ] && mkdir /mnt/server

## own server to container user
chown container: /mnt/server/

echo "Job's Done"

