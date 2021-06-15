# ----------------------------------
# Pterodactyl Dockerfile
# This image includes nodejs 14 and Redis
# Redis is available to the application inside the container on default connection settings
# Adapted from https://github.com/parkervcp/images/tree/debian/nodejs-14
# ----------------------------------
FROM catalysm/csmm:latest as csmm
FROM node:14-buster-slim

RUN apt-get update \
    && apt-get -y install build-essential wget tcl \
    && useradd -m -d /home/container container

# Install Redis
RUN wget http://download.redis.io/redis-stable.tar.gz \
    && tar xvzf redis-stable.tar.gz\
    && cd redis-stable \
    && make \
    # Create symlinks for Redis executables
    && make install

COPY --chown=container:container --from=csmm /usr/src/app /usr/src/app

# The following is some trickery to make .tmp writeable in a read-only filesystem
# See: https://stackoverflow.com/questions/37883895/can-i-have-a-writable-docker-volume-mounted-under-a-read-only-volume
# See: https://stackoverflow.com/questions/26145351/why-doesnt-chown-work-in-dockerfile
# Or: https://blog.candaele.dev/writing-inside-a-readonly-container/ :)
RUN mkdir -p /usr/src/app/.tmp/public
RUN chown -R 988:988 /usr/src/app/.tmp
VOLUME [ "/usr/src/app/.tmp" ]

RUN chown -R 988:988 /usr/src/app/views
VOLUME [ "/usr/src/app/views" ]

RUN mkdir -p /usr/src/app/exports
RUN chown -R 988:988 /usr/src/app/exports
VOLUME [ "/usr/src/app/exports" ]

USER container
ENV USER=container HOME=/home/container


WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]