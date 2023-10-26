ARG DENO_VERSION=1.37.2
FROM debian:bookworm as builder_strfry

WORKDIR /builder

RUN apt update && \
    apt install -y --no-install-recommends \
    git g++ make pkg-config libtool ca-certificates \
    libyaml-perl libtemplate-perl libregexp-grammars-perl libssl-dev zlib1g-dev \
    liblmdb-dev libflatbuffers-dev libsecp256k1-dev \
    libzstd-dev libre2-dev && \
    rm -rf /var/lib/apt/lists/*

# Build strfry
ENV STRFRY_VERSION=0.9.6
RUN git clone --branch $STRFRY_VERSION https://github.com/hoytech/strfry strfry-src
RUN cd strfry-src && git submodule update --init && make setup-golpe && make -j4 && \
    cp strfry /builder/strfry && rm -rf strfry-src

FROM node:lts-bookworm-slim as builder_node

WORKDIR /builder

RUN apt update -y && \
    apt install -y --no-install-recommends \
    git openssl ca-certificates \
    python3-dev make build-essential && \
    rm -rf /var/lib/apt/lists/*

# Prepare nostr-filter
RUN git clone --depth 1 --branch main https://github.com/atrifat/nostr-filter && \
    cd /builder/nostr-filter && \
    npm ci --omit=dev && npx tsc

# Prepare nostr-monitoring-tool
ENV NOSTR_MONITORING_TOOL_VERSION=v0.3.0
RUN git clone --depth 1 --branch $NOSTR_MONITORING_TOOL_VERSION https://github.com/atrifat/nostr-monitoring-tool && \
    cd /builder/nostr-monitoring-tool && \
    npm ci --omit=dev

# Setup deno binary image
FROM denoland/deno:bin-${DENO_VERSION} AS deno_binary

FROM node:lts-bookworm-slim as runner

WORKDIR /app

RUN apt update -y && \
    apt install -y openssl ca-certificates \
    liblmdb0 libflatbuffers2 libsecp256k1-1 libb2-1 libzstd1 libre2-9 && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/strfry/strfry-db/
RUN mkdir -p /app/logs

COPY .env.example /app/
COPY scripts/* /app/
COPY config/* /app/strfry/

COPY --from=builder_strfry /builder/strfry /app/strfry/strfry
COPY --from=deno_binary /deno /usr/bin/deno
COPY --from=builder_node /builder/nostr-filter nostr-filter
COPY --from=builder_node /builder/nostr-monitoring-tool nostr-monitoring-tool

RUN chmod +x /app/strfry/policy.ts
RUN chmod +x launch.sh

RUN chown -R node:node /app && chown -R node:node /home/node

USER node

ENV HOME=/home/node
ENV NODE_ENV=production

# ENV variable for nostr-filter
ENV UPSTREAM_HTTP_URL=http://127.0.0.1:7777
ENV UPSTREAM_WS_URL=ws://127.0.0.1:7777
ENV NOSTR_MONITORING_BOT_PUBLIC_KEY=
ENV WHITELISTED_PUBKEYS=
ENV LISTEN_PORT=7860

# ENV variable for nostr-monitoring-tool
ENV ENABLE_NSFW_CLASSIFICATION=true
ENV NSFW_DETECTOR_ENDPOINT=
ENV NSFW_DETECTOR_TOKEN=
ENV ENABLE_LANGUAGE_DETECTION=true
ENV LANGUAGE_DETECTOR_ENDPOINT=
ENV LANGUAGE_DETECTOR_TOKEN=
ENV LANGUAGE_DETECTOR_TRUNCATE_LENGTH=350
ENV NOSTR_MONITORING_BOT_PRIVATE_KEY=
ENV RELAYS_SOURCE=
ENV RELAYS_TO_PUBLISH=ws://127.0.0.1:7777
ENV DELAYS_BEFORE_PUBLISHING_NOTES=1000
ENV ENABLE_MQTT_PUBLISH=false
ENV MQTT_BROKER_TO_PUBLISH=

EXPOSE $LISTEN_PORT

ENTRYPOINT ["/app/launch.sh"]