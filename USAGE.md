# Relay Usage

## Basic Usage

nostr-filter-relay can be used and activated as relay for "Global" feed in your Nostr clients. Simply add `wss://your-nostr-filter-relay-url.example` (example url, change it into a working nostr-relay-filter url) to your nostr clients and set it to enable reading in "Global" relay settings. A public demo (beta/test) of nostr-filter-relay will be available later if you can't run your own nostr-filter-relay server.

If you don't add any parameter (?) behind the url of `wss://your-nostr-filter-relay-url.example` then it is equal to using relay with parameters as default values:

```
wss://your-nostr-filter-relay-url.example/?content=sfw&user=all&lang=all&nsfw_confidence=75&lang_confidence=15
```

You can customize the parameter based on your needs. Check **Examples** for to get the gists of how to use nostr-filter-relay.

## Examples

The following are various examples of how to use nostr-filter-relay which illustrated by some (fictional or maybe factual) scenarios. Check **Advanced Usage** sections for more information about the parameters.

Scenarios:

> **Note**
>
> "I'm new Nostr user. I don't quite understand (yet), barely know anything." (General Common Users)
>
> **Answer**
>
> Add `wss://your-nostr-filter-relay-url.example`

> **Note**
>
> "I want to introduce Nostr to my **family/colleges/friends**. Unfortunately, global feed is unbearable. Lots of sensitive content and/or NSFW posted in there. I don't want to show my family/colleges/friends any of those as their first experience."
>
> **OR**
>
> "My Nostr client is sucks. It **doesn't have** any **settings** or **toggle** button to filter NSFW or sensitive content"
>
> **Answer**
>
> Add `wss://your-nostr-filter-relay-url.example/?content=sfw`

> **Note**
>
> "I'm ok with whatever content is posted, as long as the post is **tagged** using #nsfw hashtag or **have** any **content-warning**. My nostr clients have already features to give me warning/toggle button for those contents properly, thus i can still view them later if i want. I don't like if those contents **don't have** any **tag** (**untagged**) or any **content-warning** (NIP-36)."
>
> **Answer**
>
> Add `wss://your-nostr-filter-relay-url.example/?content=partialsfw`

> **Note**
>
> "I want to make a **specialized** Nostr client for #nsfw content creator (pornhubstr). I **don't need** any **non #nsfw** content"
>
> **Answer**
>
> Add `wss://your-nostr-filter-relay-url.example/?content=nsfw`

> **Note**
>
> "LMAO, YOLO, why bother. I **don't care with whatever** anyone post. Your relay job is only to **aggregate** the contents so i don't have to connect with lots of relays (**save data bandwidth**)."
>
> **Answer**
>
> Add `wss://your-nostr-filter-relay-url.example/?content=all`

> **Note**
>
> "Hmm, i see some **bridged content** from activitypub/fediverse/mastodon (mostr.pub). I **don't want to see** any of them"
>
> **Answer**
>
> Add `wss://your-nostr-filter-relay-url.example/?user=nostr`

> **Note**
>
> "Nostr contents are boring, mostly talk about nostr and bitcoin day and night. Better **only see fedi/mastodon contents**. Hehe, activitypub FTW"
>
> **Answer**
>
> Add `wss://your-nostr-filter-relay-url.example/?user=activitypub`

> **Note**
>
> "Apaan nih isinya bule semua. Warga +62 mana suaranya ya?" (context simplified: I'm **Indonesian**)
>
> **Answer**
>
> Add `wss://your-nostr-filter-relay-url.example/?lang=id`

> **Note**
>
> "我说中文和日文, 私は中国語と日本語で話します" (translated: I speak in **Chinese** and **Japanese**)
>
> **Answer**
>
> Add `wss://your-nostr-filter-relay-url.example/?lang=zh,ja`

> **Note**
>
> "There are still some **false positive** (Non-NSFW content is classified as NSFW) in your filter relay. I will adjust and **increase** the minimum confidence thresold percentage on my own."
>
> **Answer**
>
> Add `wss://your-nostr-filter-relay-url.example/?nsfw_confidence=85` (default value: 75, valid value: 0-100)

> **Note**
>
> "There are still some **false negative** (NSFW content is classified as Non-NSFW) in your filter relay. I will adjust and **lower** the minimum confidence thresold percentage on my own."
>
> **Answer**
>
> Add `wss://your-nostr-filter-relay-url.example/?nsfw_confidence=60` (default value: 75, valid value: 0-100)

> **Note**
>
> "Your language detection have lots of **false positive**. I will **adjust** the confidence **thresold** percentage on my own."
>
> **Answer**
>
> Add `wss://your-nostr-filter-relay-url.example/?lang_confidence=65` (default value: 15, valid value: 0-100)

> **Note**
>
> "I want to see english content. It should be highly accurate"
>
> **Answer**
>
> Add `wss://your-nostr-filter-relay-url.example/?lang=en&lang_confidence=85` (default value: 15, valid value: 0-100)

> **Note**
>
> "I want to see content from Arabic users. It should be highly accurate, with minimum 90 thresold score. Also, i don't want to see any sensitive content (with minimum thresold score: 50) and activitypub content"
>
> **Answer**
>
> Add `wss://your-nostr-filter-relay-url.example/?lang=ar&lang_confidence=90&content=sfw&nsfw_confidence=50&user=nostr` (multiple parameters)

> **Note**
>
> "Your filter relay software is sucks"
>
> **Answer**
>
> Agree, thank you. Currently, this is still **PoC (demo/test/beta)** quality. Hopefully, better softwares will come eventually. Feel free to fork and/or adjust the related software, code, or settings. Better PR will be happily appreciated https://github.com/atrifat/nostr-filter-relay/pulls

> **Note**
>
> "f\*\*k don't tell me anything, don't censor my CAT post!!! f\*\*\*ing censorship!!!"
>
> **Answer**
>
> Hi, feel free to add the relay into your nostr clients and adjust the parameters based on your need. It is up to **you/me/us/anyone** whether **you/me/us/anyone** want to add the relay or not. Have a good day, thank you :)
