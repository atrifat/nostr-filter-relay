# Relay Usage

## Basic Usage

nostr-filter-relay can be used and activated as relay for "Global" feed in our Nostr clients. Simply add `wss://nfrelay.app` (public demo relay, or change it into our own nostr-relay-filter url) to our nostr clients and set it to enable reading in "Global" relay settings.

If we don't add any parameter (?) behind the url of `wss://nfrelay.app` then it is equal to using relay with parameters using its default parameter values:

`wss://nfrelay.app/?user=all&lang=all&content=sfw&nsfw_confidence=75&lang_confidence=15&toxic=no&toxic_confidence=75&sentiment=all&sentiment_confidence=35&topic=all&topic_confidence=35`

Default values above will make relay filter events focus on **"General common users"** by serving **'family-friendly'** note events by default. However, we can customize the parameter (using single or multiple parameters) based on our needs. Check **[Advanced Usage](#advanced-usage)** to get the gists on how to use nostr-filter-relay in various settings.

## Advanced Usage

The following are various examples on how to use nostr-filter-relay which illustrated by some (fictional or maybe factual) scenarios.

### Content Type (SFW/NSFW) Filtering Example

> **Note**
>
> "I'm new Nostr user. I don't quite understand (yet), barely know anything." (General Common Users)
>
> **Answer**
>
> Add `wss://nfrelay.app`

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
> Add `wss://nfrelay.app/?content=sfw`

> **Note**
>
> "I'm ok with whatever content is posted, as long as the post is **tagged** using #nsfw hashtag or **have** any **content-warning**. My nostr clients have already features to give me warning/toggle button for those contents properly, thus i can still view them later if i want. I don't like if those contents **don't have** any **tag** (**untagged**) or any **content-warning** (NIP-36)."
>
> **Answer**
>
> Add `wss://nfrelay.app/?content=partialsfw`

> **Note**
>
> "I want to make a **specialized** Nostr client for #nsfw content creator (pornhubstr). I **don't need** any **non #nsfw** content"
>
> **Answer**
>
> Add `wss://nfrelay.app/?content=nsfw`

> **Note**
>
> "LMAO, YOLO, why bother. I **don't care with whatever** anyone post. Your relay job is only to **aggregate** the contents so i don't have to connect with lots of relays (**save data bandwidth**)."
>
> **Answer**
>
> Add `wss://nfrelay.app/?content=all`

### User Type Filtering Example

> **Note**
>
> "Hmm, i see some **bridged content** from activitypub/fediverse/mastodon (mostr.pub). I **don't want to see** any of them"
>
> **Answer**
>
> Add `wss://nfrelay.app/?user=nostr`

> **Note**
>
> "Nostr contents are boring, mostly talk about nostr and bitcoin day and night. Better **only see fedi/mastodon contents**. Hehe, activitypub FTW"
>
> **Answer**
>
> Add `wss://nfrelay.app/?user=activitypub`

### Language Filtering Example

> **Note**
>
> "Apaan nih isinya bule semua. Warga +62 mana suaranya ya?" (context simplified: I'm **Indonesian**)
>
> **Answer**
>
> Add `wss://nfrelay.app/?lang=id`

> **Note**
>
> "我说中文和日文, 私は中国語と日本語で話します" (translated: I speak in **Chinese** and **Japanese**)
>
> **Answer**
>
> Add `wss://nfrelay.app/?lang=zh,ja`

### Hate speech (Toxic comments) Filtering Example

> **Note**
>
> "I don't want to see any insult, vulgar comment, identity hate, or any toxic comments"
>
> **Answer**
>
> Add `wss://nfrelay.app/?toxic=no` (default value: no, valid value: no, yes, all)

> **Note**
>
> "I don't care whether to see insult, vulgar comment, identity hate, or any toxic comments"
>
> **Answer**
>
> Add `wss://nfrelay.app/?toxic=all` (default value: no, valid value: no, yes, all)

> **Note**
>
> "I want to see only insult, vulgar comment, identity hate, or any toxic comments"
>
> **Answer**
>
> Add `wss://nfrelay.app/?toxic=yes` (default value: no, valid value: no, yes, all)

> **Note**
>
> "I don't want to see any insult, vulgar comment, identity hate, or any toxic comments. I want to set minimum probability score to be high (90% minimum score)."
>
> **Answer**
>
> Add `wss://nfrelay.app/?toxic=no&toxic_confidence=90` (default toxic_confidence: 75, valid value: 0-100)

### Sentiment Filtering Example

> **Note**
>
> "I wanna see positive and neutral posts only."
>
> **Answer**
>
> Add `wss://nfrelay.app/?sentiment=positive,neutral`

> **Note**
>
> "My life is full of happiness. I wanna see some negativity to balance it :P"
>
> **Answer**
>
> Add `wss://nfrelay.app/?sentiment=negative`

> **Note**
>
> "I want to see neutral posts with minimum confidence/probability score 70%"
>
> **Answer**
>
> Add `wss://nfrelay.app/?sentiment=neutral&sentiment_confidence=70` (default value: 35, valid value: 0-100)

### Topic Filtering Example

> **Note**
>
> "I prefer getting updates on news, business information, and technology."
>
> **Answer**
>
> Add `wss://nfrelay.app/?topic=news,business,technology` (short version) or `wss://nfrelay.app/?topic=news_and_social_concern,business_and_entrepreneurs,science_and_technology` if user want to state clearly the topic category. List of known topics were provided [below](#known-topic-category).

> **Note**
>
> "My favorite discussions are related to music and sport."
>
> **Answer**
>
> Add `wss://nfrelay.app/?topic=music,sport`

> **Note**
>
> "I want my feeds focused on game with minimum confidence score is 70%"
>
> **Answer**
>
> Add `wss://nfrelay.app/?topic=gaming&topic_confidence=70` (default confidence value: 35, valid value: 0-100)

#### Known Topic Category

List of currently known topic category in nostr-filter-relay were listed as follows:

1. **arts_and_culture** (short version: "**art**" or "**culture**")
2. **business_and_entrepreneurs** (short version: "**business**" or "**entrepreneur**")
3. **celebrity_and_pop_culture** (short version: "**celebrity**" or "**pop**")
4. **diaries_and_daily_life** (short version: "**diaries**" or "**daily**")
5. **family**
6. **fashion_and_style** (short version: "**fashion**" or "**style**")
7. **film_tv_and_video** (short version: "**film**", or "**tv**", or "**video**")
8. **fitness_and_health** (short version: "**fitness**" or "**health**")
9. **food_and_dining** (short version: "**food**" or "**dining**")
10. **gaming**
11. **learning_and_educational** (short version: "**learning**" or "**educational**")
12. **music**
13. **news_and_social_concern** (short version: "**news**" or "**social**")
14. **other_hobbies**
15. **relationships**
16. **science_and_technology** (short version: "**science**" or "**technology**")
17. **sports**
18. **travel_and_adventure** (short version: "**travel**" or "**adventure**")
19. **youth_and_student_life** (short version: "**youth**" or "**student**")

Topic classification were categorized based on previous research from [Cardiff University - Twitter Topic Classification](https://huggingface.co/cardiffnlp/twitter-roberta-base-dec2021-tweet-topic-multi-all).

### Confidence Score Filtering Example

> **Note**
>
> "There are still some **false positive** (Non-NSFW content is classified as NSFW) in your filter relay. I will adjust and **increase** the minimum confidence thresold percentage on my own."
>
> **Answer**
>
> Add `wss://nfrelay.app/?nsfw_confidence=85` (default value: 75, valid value: 0-100)

> **Note**
>
> "There are still some **false negative** (NSFW content is classified as Non-NSFW) in your filter relay. I will adjust and **lower** the minimum confidence thresold percentage on my own."
>
> **Answer**
>
> Add `wss://nfrelay.app/?nsfw_confidence=60` (default value: 75, valid value: 0-100)

> **Note**
>
> "Your language detection have lots of **false positive**. I will **adjust** the confidence **thresold** percentage on my own."
>
> **Answer**
>
> Add `wss://nfrelay.app/?lang_confidence=65` (default value: 15, valid value: 0-100)

### Multiple Parameters Filtering Example

> **Note**
>
> "I want to see english content. It should be highly accurate"
>
> **Answer**
>
> Add `wss://nfrelay.app/?lang=en&lang_confidence=85` (default value: 15, valid value: 0-100)

> **Note**
>
> "I want to see content from Arabic users. It should be highly accurate, with minimum 90 thresold score. Also, i don't want to see any sensitive content (with minimum thresold score: 50) and activitypub content"
>
> **Answer**
>
> Add `wss://nfrelay.app/?lang=ar&lang_confidence=90&content=sfw&nsfw_confidence=50&user=nostr` (multiple parameters)

## Non Example

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
