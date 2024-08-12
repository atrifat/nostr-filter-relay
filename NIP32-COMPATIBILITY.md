# NIP-32 Event Compatibility for nostr-filter-relay

Currently (until v0.3.0), custom event kind (9978) have been used internally for classification/labelling event in [nostr-filter-relay](https://github.com/atrifat/nostr-filter-relay). To make a better compatibility with [NIP-32](https://github.com/nostr-protocol/nips/blob/master/32.md), custom event kind 9978 will be migrated and reimplemented into NIP-32 event structure as described in the following draft.

## Table of Content

- [Table of Content](#table-of-content)
- [Language Label](#language-label)
- [Content-safety Label](#content-safety-label)
- [Toxicity Label](#toxicity-label)
- [Sentiment Label](#sentiment-label)
- [Topic Label](#topic-label)
- [References](#references)

## Language Label

Original event structure (kind: 9978) example implemented in nostr-filter-relay

```json
{
    "kind": 9978,
    "tags":[
        ["d","nostr-language-classification"],
        ["t","nostr-language-classification"],
        ["e","eventId"],
        ["p","originalAuthorHexPubkey"]
    ],
    "content":"[{\"confidence\":0.87,\"language\":\"en\"}]"
}
```

The label were encoded as JSON stringified into content field. Original event structure didn't offer capability to query label event easily.

### Language Label (Single Label)

Proposed NIP-32 event structure

```json
{
    "kind": 1985,
    "tags": [
        ["e","eventId","wss://nfrelay.app"],
        ["p","originalAuthorHexPubkey"],
        ["L","ISO-639-1"],
        ["L","app.nfrelay.language"],
        ["label_minimum_score","app.nfrelay.language", "0.35"],
        ["label_score_type","app.nfrelay.language", "float"],
        ["label_model","app.nfrelay.language","atrifat/language-detector-api","https://github.com/atrifat/language-detector-api"],
        ["l","en","ISO-639-1"],
        ["l","en","app.nfrelay.language"],
        ["label_score","en","app.nfrelay.language", "0.87"],
    ]
}
```

This example use two different namespace ("ISO-639-1", "app.nfrelay.language") to support compatibility for labelling event in different apps. General nostr apps can request query to relay using tags `["L","ISO-639-1"]` followed by `["l","en"]` to fetch english labelling event. Namespace of `["L","app.nfrelay.language"]` will be used internally on nostr-filter-relay. Other non-indexing tags such as `label_score_type`, `label_model`, `label_score` will be used internally for nostr-filter-relay to maintain data structure similar to original event (kind: 9978).

### Language Label (Multi Label)

Example of multi label language event structure

```json
{
    "kind": 1985,
    "tags": [
        ["e","eventId","wss://nfrelay.app"],
        ["p","originalAuthorHexPubkey"],
        ["L","ISO-639-1"],
        ["L","app.nfrelay.language"],
        ["label_minimum_score","app.nfrelay.language", "0.35"],
        ["label_score_type","app.nfrelay.language", "float"],
        ["label_model","app.nfrelay.language","atrifat/language-detector-api","https://github.com/atrifat/language-detector-api"],
        ["l","en","ISO-639-1"],
        ["l","en","app.nfrelay.language"],
        ["label_score","en","app.nfrelay.language","0.55"],
        ["l","ja","ISO-639-1"],
        ["l","ja","app.nfrelay.language"],
        ["label_score","ja","app.nfrelay.language","0.45"],
    ]
}
```

This example show the use case for multiple label language. There are cases when notes (kind:1) have multiple language thus need multiple label.

## Content-safety Label

**Original event structure (kind: 9978) example implemented in nostr-filter-relay**

```json
{
    "kind": 9978,
    "tags":[
        ["d","nostr-nsfw-classification"],
        ["t","nostr-nsfw-classification"],
        ["e","eventId"],
        ["p","originalAuthorHexPubkey"]],
    "content":"[{\"id\":\"eventId\",\"author\":\"originalAuthorHexPubkey\",\"is_activitypub_user\":true,\"has_content_warning\":false,\"has_nsfw_hashtag\":false,\"probably_nsfw\":false,\"high_probably_nsfw\":false,\"responsible_nsfw\":true,\"data\":{\"hentai\":0.1,\"neutral\":0.7,\"pornography\":0.1,\"sexy\":0.1,\"predictedLabel\":\"neutral\"},\"url\":\"https://example1/image.jpg\"}]",
}
```

There are lots of verbose extra data encoded in content field. In proposed structure we reduce and minimize the structure as follows.

**Proposed Single label (single link) event structure for SFW content example:**

```json
{
    "kind": 1985,
    "tags": [
        ["e","eventId","wss://nfrelay.app"],
        ["p","originalAuthorHexPubkey"],
        ["L","app.nfrelay.content-safety"],
        ["label_schema","app.nfrelay.content-safety","sfw","nsfw"],
        ["label_schema_original","app.nfrelay.content-safety","hentai","neutral","pornography","sexy"],
        ["label_minimum_score","app.nfrelay.content-safety", "0.5"],
        ["label_score_type","app.nfrelay.content-safety", "float"],
        ["label_model","app.nfrelay.content-safety","atrifat/nsfw-detector-api","https://github.com/atrifat/nsfw-detector-api"],
        ["l","sfw","app.nfrelay.content-safety"],
        ["label_score","sfw","app.nfrelay.content-safety", "0.7","https://example1/image.jpg"],
        ["label_score","hentai","app.nfrelay.content-safety", "0.1","https://example1/image.jpg"],
        ["label_score","neutral","app.nfrelay.content-safety", "0.7","https://example1/image.jpg"],
        ["label_score","pornography","app.nfrelay.content-safety", "0.1","https://example1/image.jpg"],
        ["label_score","sexy","app.nfrelay.content-safety", "0.1","https://example1/image.jpg"],
    ]
}
```

**Proposed Single label (single link) event structure for NSFW content example:**

```json
{
    "kind": 1985,
    "tags": [
        ["e","eventId","wss://nfrelay.app"],
        ["p","originalAuthorHexPubkey"],
        ["L","app.nfrelay.content-safety"],
        ["label_schema","app.nfrelay.content-safety","sfw","nsfw"],
        ["label_schema_original","app.nfrelay.content-safety","hentai","neutral","pornography","sexy"],
        ["label_minimum_score","app.nfrelay.content-safety", "0.5"],
        ["label_score_type","app.nfrelay.content-safety", "float"],
        ["label_model","app.nfrelay.content-safety","atrifat/nsfw-detector-api","https://github.com/atrifat/nsfw-detector-api"],
        ["l","nsfw","app.nfrelay.content-safety"],
        ["label_score","nsfw","app.nfrelay.content-safety", "0.9","https://example1/image.jpg"],
        ["label_score","hentai","app.nfrelay.content-safety", "0.7","https://example1/image.jpg"],
        ["label_score","neutral","app.nfrelay.content-safety", "0.1","https://example1/image.jpg"],
        ["label_score","pornography","app.nfrelay.content-safety", "0.1","https://example1/image.jpg"],
        ["label_score","sexy","app.nfrelay.content-safety", "0.1","https://example1/image.jpg"],
    ]
}
```

**Proposed Multi label (Multi link) event structure:**

```json
{
    "kind": 1985,
    "tags": [
        ["e","eventId","wss://nfrelay.app"],
        ["p","originalAuthorHexPubkey"],
        ["L","app.nfrelay.content-safety"],
        ["label_schema","app.nfrelay.content-safety","sfw","nsfw"],
        ["label_schema_original","app.nfrelay.content-safety","hentai","neutral","pornography","sexy"],
        ["label_minimum_score","app.nfrelay.content-safety", "0.5"],
        ["label_model","app.nfrelay.content-safety","atrifat/nsfw-detector-api","https://github.com/atrifat/nsfw-detector-api"],
        ["l","nsfw","app.nfrelay.content-safety"],
        ["label_score","nsfw","app.nfrelay.content-safety", "0.9","https://example1/image.jpg"],
        ["label_score","hentai","app.nfrelay.content-safety", "0.7","https://example1/image.jpg"],
        ["label_score","neutral","app.nfrelay.content-safety", "0.1","https://example1/image.jpg"],
        ["label_score","pornography","app.nfrelay.content-safety", "0.1","https://example1/image.jpg"],
        ["label_score","sexy","app.nfrelay.content-safety", "0.1","https://example1/image.jpg"],
        ["l","sfw","app.nfrelay.content-safety"],
        ["label_score","sfw","app.nfrelay.content-safety", "0.8","https://example2/image.jpg"],
        ["label_score","hentai","app.nfrelay.content-safety", "0.1","https://example2/image.jpg"],
        ["label_score","neutral","app.nfrelay.content-safety", "0.8","https://example2/image.jpg"],
        ["label_score","pornography","app.nfrelay.content-safety", "0.0","https://example2/image.jpg"],
        ["label_score","sexy","app.nfrelay.content-safety", "0.1","https://example2/image.jpg"],
    ]
}
```

Notes (kind:1) can have multiple link/url with different label result for each url/link.

## Toxicity Label

**Original event structure (kind: 9978) example implemented in nostr-filter-relay**

```json
{
    "kind": 9978,
    "tags":[
        ["d","nostr-hate-speech-classification"],
        ["t","nostr-hate-speech-classification"],
        ["e","eventId"],
        ["p","originalAuthorHexPubkey"]
    ],
    "content":"{\"identity_attack\":0.65,\"insult\":0.0,\"obscene\":0.0,\"severe_toxicity\":0.25,\"sexual_explicit\":0.0,\"threat\":0.0,\"toxicity\":0.6}"
}
```

**Proposed NIP-32 event (toxic example)**

```json
{
    "kind": 1985,
    "tags": [
        ["e","eventId","wss://nfrelay.app"],
        ["p","originalAuthorHexPubkey"],
        ["L","app.nfrelay.toxicity"],
        ["label_schema","app.nfrelay.toxicity","toxic","non-toxic"],
        ["label_schema_original","app.nfrelay.toxicity","identity_attack","insult","obscene","severe_toxicity","sexual_explicit","threat","toxicity"],
        ["label_model","app.nfrelay.toxicity","atrifat/hate-speech-detector-api","https://github.com/atrifat/hate-speech-detector-api"],
        ["label_minimum_score","app.nfrelay.toxicity", "0.5"],
        ["l","toxic","app.nfrelay.content-safety"],
        ["label_score","toxic","app.nfrelay.toxicity", "0.65"],
        ["label_score","identity_attack","app.nfrelay.toxicity", "0.65"],
        ["label_score","insult","app.nfrelay.toxicity", "0.0"],
        ["label_score","obscene","app.nfrelay.toxicity", "0.0"],
        ["label_score","severe_toxicity","app.nfrelay.toxicity", "0.25"],
        ["label_score","sexual_explicit","app.nfrelay.toxicity", "0.0"],
        ["label_score","threat","app.nfrelay.toxicity", "0.0"],
        ["label_score","toxicity","app.nfrelay.toxicity", "0.6"],
    ]
}
```

**Proposed NIP-32 event (non-toxic example)**

```json
{
    "kind": 1985,
    "tags": [
        ["e","eventId","wss://nfrelay.app"],
        ["p","originalAuthorHexPubkey"],
        ["L","app.nfrelay.toxicity"],
        ["label_schema","app.nfrelay.toxicity","toxic","non-toxic"],
        ["label_schema_original","app.nfrelay.toxicity","identity_attack","insult","obscene","severe_toxicity","sexual_explicit","threat","toxicity"],
        ["label_model","app.nfrelay.toxicity","atrifat/hate-speech-detector-api","https://github.com/atrifat/hate-speech-detector-api"],
        ["label_minimum_score","app.nfrelay.toxicity", "0.5"],
        ["l","non-toxic","app.nfrelay.content-safety"],
        ["label_score","non-toxic","app.nfrelay.toxicity", "0.8"],
        ["label_score","identity_attack","app.nfrelay.toxicity", "0.0"],
        ["label_score","insult","app.nfrelay.toxicity", "0.0"],
        ["label_score","obscene","app.nfrelay.toxicity", "0.0"],
        ["label_score","severe_toxicity","app.nfrelay.toxicity", "0.0"],
        ["label_score","sexual_explicit","app.nfrelay.toxicity", "0.0"],
        ["label_score","threat","app.nfrelay.toxicity", "0.1"],
        ["label_score","toxicity","app.nfrelay.toxicity", "0.2"],
    ]
}
```

## Sentiment Label

**Original event structure (kind: 9978) example implemented in nostr-filter-relay**

```json
{
    "kind": 9978,
    "tags":[
        ["d","nostr-sentiment-classification"],
        ["t","nostr-sentiment-classification"],
        ["e","eventId"],
        ["p","originalAuthorHexPubkey"]
    ],
    "content":"{\"negative\":0.1,\"neutral\":0.55,\"positive\":0.35}"
}
```

**Proposed NIP-32 event**

```json
{
    "kind": 1985,
    "tags": [
        ["e","eventId","wss://nfrelay.app"],
        ["p","originalAuthorHexPubkey"],
        ["L","app.nfrelay.sentiment"],
        ["label_schema","app.nfrelay.sentiment","negative","neutral","positive"],
        ["label_schema_original","app.nfrelay.sentiment","negative","neutral","positive"],
        ["label_model","app.nfrelay.sentiment","atrifat/sentiment-analysis-api","https://github.com/atrifat/sentiment-analysis-api"],
        ["label_minimum_score","app.nfrelay.sentiment", "0.35"],
        ["l","neutral","app.nfrelay.sentiment"],
        ["label_score","negative","app.nfrelay.sentiment", "0.1"],
        ["label_score","neutral","app.nfrelay.sentiment", "0.55"],
        ["label_score","positive","app.nfrelay.sentiment", "0.35"],
    ]
}
```

## Topic Label

**Original event structure (kind: 9978) example implemented in nostr-filter-relay**

```json
{
    "kind": 9978,
    "tags":[
        ["d","nostr-topic-classification"],
        ["t","nostr-topic-classification"],
        ["e","eventId"],
        ["p","originalAuthorHexPubkey"]
    ],
    "content":"[{\"label\":\"science_and_technology\",\"score\":0.55},{\"label\":\"arts_and_culture\",\"score\":0.35},{\"label\":\"music\",\"score\":0.2}]"
}
```

Topic classification were categorized based on previous research from [Cardiff University - Twitter Topic Classification](https://huggingface.co/cardiffnlp/twitter-roberta-base-dec2021-tweet-topic-multi-all).

**Proposed NIP-32 event**

```json
{
    "kind": 1985,
    "tags": [
        ["e","eventId","wss://nfrelay.app"],
        ["p","originalAuthorHexPubkey"],
        ["L","app.nfrelay.topic"],
        ["label_schema","app.nfrelay.topic","arts_and_culture","business_and_entrepreneurs","celebrity_and_pop_culture","diaries_and_daily_life","family","fashion_and_style","film_tv_and_video","fitness_and_health","food_and_dining","gaming","learning_and_educational","music","news_and_social_concern","other_hobbies","relationships","science_and_technology","sports","travel_and_adventure","youth_and_student_life"],
        ["label_schema_original","app.nfrelay.topic","arts_&_culture","business_&_entrepreneurs","celebrity_&_pop_culture","diaries_&_daily_life","family","fashion_&_style","film_tv_&_video","fitness_&_health","food_&_dining","gaming","learning_&_educational","music","news_&_social_concern","other_hobbies","relationships","science_&_technology","sports","travel_&_adventure","youth_&_student_life"],
        ["label_model","app.nfrelay.topic","atrifat/topic-classification-api","https://github.com/atrifat/topic-classification-api"],
        ["label_minimum_score","app.nfrelay.topic", "0.35"],
        ["l","science_and_technology","app.nfrelay.topic"],
        ["label_score","science_and_technology","app.nfrelay.topic", "0.55"],
        ["l","arts_and_culture","app.nfrelay.topic"],
        ["label_score","arts_and_culture","app.nfrelay.topic", "0.35"],
        ["label_score","music","app.nfrelay.topic", "0.2"],
    ]
}
```

**Compatibility with different namespace (social.ontolo.categories) possibility example**

```json
{
    "kind": 1985,
    "tags": [
        ["e","eventId","wss://nfrelay.app"],
        ["p","originalAuthorHexPubkey"],
        ["L","app.nfrelay.topic"],
        ["label_schema","arts_and_culture","business_and_entrepreneurs","celebrity_and_pop_culture","diaries_and_daily_life","family","fashion_and_style","film_tv_and_video","fitness_and_health","food_and_dining","gaming","learning_and_educational","music","news_and_social_concern","other_hobbies","relationships","science_and_technology","sports","travel_and_adventure","youth_and_student_life"],
        ["label_schema_original","arts_&_culture","business_&_entrepreneurs","celebrity_&_pop_culture","diaries_&_daily_life","family","fashion_&_style","film_tv_&_video","fitness_&_health","food_&_dining","gaming","learning_&_educational","music","news_&_social_concern","other_hobbies","relationships","science_&_technology","sports","travel_&_adventure","youth_&_student_life"],
        ["label_model","app.nfrelay.topic","atrifat/topic-classification-api","https://github.com/atrifat/topic-classification-api"],
        ["label_minimum_score", "0.35"],
        ["l","science_and_technology","app.nfrelay.topic"],
        ["label_score","science_and_technology","app.nfrelay.topic", "0.55"],
        ["l","arts_and_culture","app.nfrelay.topic"],
        ["label_score","arts_and_culture","app.nfrelay.topic", "0.35"],
        ["label_score","music","app.nfrelay.topic", "0.2"],
        ["L","social.ontolo.categories"],
        ["l","Science & Technology/Formal Sciences","social.ontolo.categories"],
    ]
}
```

Unfortunately, due to different label categorization method, not all categories can be mapped directly thus this example has been used as showcase for possible use case implementation.

## References

- [NIP-32](https://github.com/nostr-protocol/nips/blob/master/32.md)
- [ontolo.social](https://github.com/erskingardner/ontolo/blob/3ce826d3304e43a024109fbf270f016a0afbea38/src/lib/components/LabelForm.svelte#L65) code implementation
