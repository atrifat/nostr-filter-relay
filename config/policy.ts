#!/bin/sh
//bin/true; exec /usr/bin/deno run -A "$0" "$@"
import {
  antiDuplicationPolicy,
  hellthreadPolicy,
  pipeline,
  rateLimitPolicy,
  readStdin,
  writeStdout,
  keywordPolicy,
} from 'https://gitlab.com/soapbox-pub/strfry-policies/-/raw/develop/mod.ts';

for await (const msg of readStdin()) {
  const result = await pipeline(msg, [
    [hellthreadPolicy, { limit: 100 }],
    [antiDuplicationPolicy, { databaseUrl:'sqlite:memory', ttl: 60000, minLength: 50 }],
    [rateLimitPolicy, { whitelist: ['127.0.0.1', '172.20.0.1'] }],
    [keywordPolicy,['oink','honk','t.me','isab.run','dosoos','beacons.ai','binance.eth',
                    'claim free','claim your','claim airdrop','zhub.link','telegra.ph','New OP_RETURN',
                    'avive.world'
    ]],
  ]);

  writeStdout(result);
}
