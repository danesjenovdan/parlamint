# Parlamint Parlameter bootstrapping setup

## Requirements
- linux
- docker
- docker-compose

## How to?

Just run `bootstrap.sh` with your country code of choice as the first argument
and follow the prompts. You'll have to enter your sudo password for docker to
be able to run its commands.

Example bootstrapping of Slovenian data
```
$ ./bootstrap.sh SI
```

### I want to change my lemmatizer
No problem, just override `lemmatize_many` in `parladata/parlacards/scores/common.py`.

### I want to change my SOLR config
No problem, just edit `parlasearch/solr/parlasearch-conf/schema.xml` and
`parlasearch/solr/parlasearch-conf/solrconfig.xml`.

### How do I run individual steps?
Peek into `bootstrap.sh`. You'll find each step sorrounded by explanatory
`echo` calls.
