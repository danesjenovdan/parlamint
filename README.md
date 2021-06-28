# Parlamint Parlameter bootstrapping setup

## What is this for?
This is to set up your own Parlameter with the data from the Parlamint corpus.
Once you have the below requirements installed you only need to run a single
command and everything will be set up for you.

The script automatically downloads data from the Clarin repository 
[Multilingual comparable corpora of parliamentary debates ParlaMint 2.1](https://www.clarin.si/repository/xmlui/handle/11356/1432) for the specified country.

After it's done (actually, even before it's done) you'll be able to access Parlameter
website at http://localhost:3066/ and the API at http://localhost:8000/. It will
also automatically set up a PostgreSQL database for you as well as a SOLR instance.

All of the commands run inside containers so they will not ~pollute~ affect your
local setup.

## Requirements
- make sure you run `git submodule update --init --recursive` to get all the code
- Linux
- [Docker](https://docs.docker.com/engine/install/)
- [docker-compose](https://docs.docker.com/compose/install/)
- an internet connection
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
