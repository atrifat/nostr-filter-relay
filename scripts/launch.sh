#!/bin/bash
# This launch script will run the following programs: strfry relay, nostr-monitoring-tool, and nostr-filter

# Run strfry relay as backend relay
touch /app/logs/strfry.log
# bash -c 'while true;do cd /app/strfry/;/app/strfry/strfry relay > /app/logs/strfry.log 2>&1;done' & true
bash -c 'while true;do cd /app/strfry/;/app/strfry/strfry relay > /dev/null 2>&1;done' & true

# Run nostr-monitoring-tool
touch /app/logs/nmt.log
bash -c 'while true;do cd "/app/nostr-monitoring-tool/";node "/app/nostr-monitoring-tool/src/index.mjs" >> /app/logs/nmt.log 2>&1;done' & true
# bash -c 'while true;do cd "/app/nostr-monitoring-tool/";node "/app/nostr-monitoring-tool/src/index.mjs" > /dev/null 2>&1;done' & true

# Run nostr-filter relay as frontend relay proxy for strfry relay
touch /app/logs/nf.log
bash -c 'while true;do cd "/app/nostr-filter/";node "/app/nostr-filter/filter.js" >> /app/logs/nf.log 2>&1;done' & true
# bash -c 'while true;do cd "/app/nostr-filter/";node "/app/nostr-filter/filter.js" > /dev/null 2>&1;done' & true

tail -F /app/logs/strfry.log /app/logs/nf.log /app/logs/nmt.log
