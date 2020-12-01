# COVID-19 and mental health

*This project was done as part of Barcelona GSE masters in data science.*

## Overview

This app provides a striaght-forward interface for users to monitor COVID-19 and its potential effect on mental health across the world. It provides a general overview of current COVID case numbers and relates them to tweets streamed in real-time that relate to mental health.

## Usage

The app is hosted on shinyapps.io. Due to usage limits the server may not always be accessible. A more robust way to access the app is through Docker. Simply run

```
```

R users not familiar with docker may prefer to install the app as an R package and run it through R Studio. To do so first install the package through:

```
```

Then simply run `run_app()`.

## Data

We source data from two different APIs: for COVID case numbers we use [https://covid19-api.org/](https://covid19-api.org/) which continuously collects case numbers at country level from across the globe; for tweets we user Twitter streaming API. COVID data is sourced from the API a few times every day.   
Tweets are steamed continuously. We stream tweets involving terms in this list `["mental health", "suicide", "depression"]` and dumb the entire JSON objects into our Mongo data base - we thought about filtering out retweets, but decided that the number of times a tweet gets retweeted may be interesting information. At a later stage in the project we will filter this down further. In particular we plan to look for cases among the tweets that also involve `"covid"` or related terms. 
