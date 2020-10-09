FROM python:3.9-alpine

LABEL maintainer frosty5689 <frosty5689@gmail.com>

RUN apk add --no-cache --update \
    ca-certificates \
    tzdata \
    && update-ca-certificates \
    && rm -rf /root/.cache

ENV PLEX_SECTION=Anime \
    PLEX_URL=localhost \
    PLEX_TOKEN='' \
    ANI_USERNAME='' \
    ANI_TOKEN='' \
    INTERVAL=3600

ENV PATH="${PATH}:~/.local/bin"

ARG PLEXANISYNC_VERSION=master

RUN apk add --no-cache --update --virtual build-dependencies wget unzip && \
    wget https://github.com/RickDB/PlexAniSync/archive/$PLEXANISYNC_VERSION.zip && \
    unzip master.zip && \
    rm master.zip && \
    mv /PlexAniSync-master /plexanisync && \
    cd /plexanisync && \
    python3 -m pip install -r requirements.txt && \
    cd .. && \
    apk del build-dependencies

ADD run/* /plexanisync

VOLUME /config

WORKDIR /plexanisync

CMD ["/plexanisync/start.sh"]
