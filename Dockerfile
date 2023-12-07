ARG DENO_VERSION=1.38.5
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
    git openssl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Prepare nostr-filter
ENV NOSTR_FILTER_COMMIT_HASH_VERSION=0351e7d0ed31ec6d0b87552d20d839b25b5c7545
ENV NOSTR_FILTER_BRANCH=main
RUN git clone --branch $NOSTR_FILTER_BRANCH https://github.com/atrifat/nostr-filter && \
    cd /builder/nostr-filter && \
    git reset --hard $NOSTR_FILTER_COMMIT_HASH_VERSION && \
    git clean -df && \
    npm ci --omit=dev && npx tsc

# Prepare nostr-monitoring-tool
ENV NOSTR_MONITORING_TOOL_VERSION=v0.4.2
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
COPY README.md /app/
COPY USAGE.md /app/
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
ENV ENABLE_FORWARD_REQ_HEADERS=false
# (Default: sfw, Options: all, sfw, partialsfw, and nsfw) Filter hate speech (toxic comment).
ENV DEFAULT_FILTER_CONTENT_MODE=sfw
# (Optional. Default: 75, Options: 0-100) Default minimum probability/confidence score to determine the classification of nsfw content
ENV DEFAULT_FILTER_NSFW_CONFIDENCE=75
# (Default: all, Multiple Options: all, or other language code)
ENV DEFAULT_FILTER_LANGUAGE_MODE=all
# (Default: 15, Options: 0-100) Default minimum probability/confidence score to determine the classification of language
ENV DEFAULT_FILTER_LANGUAGE_CONFIDENCE=15
# (Default: no, Options: all, no, yes) Filter hate speech (toxic comment). "all" will disable filtering, "no" will filter out any detected hate speech content, "yes" will select only detected hate speech content
ENV DEFAULT_FILTER_HATE_SPEECH_TOXIC_MODE=no
# (Default: 75, Options: 0-100) Default minimum probability/confidence score to determine the classification of hate speech (toxic comment)
ENV DEFAULT_FILTER_HATE_SPEECH_TOXIC_CONFIDENCE=75
# (Default: max, Options: max, sum) Methods to determine toxic content by using max value from all toxic classes score or sum value of all toxic classes score
ENV DEFAULT_FILTER_HATE_SPEECH_TOXIC_EVALUATION_MODE=max
# (Default: all, Options: all, nostr, activitypub) Filter user type. "nostr" for native nostr users and "activitypub" for activitypub users coming from bridge
ENV DEFAULT_FILTER_USER_MODE=all

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