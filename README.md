# bgse-dw-final-project

Group final project for Barcelona GSE Data Warehousing course

## Relating COVID-19 to mental health

In this project we aim to explore potential links between COVID-19 and mental health by relating case numbers to tweets revolving around mental health. Questions that come to mind and should be straight-forward to answer include: does Twitter activity around mental health increase as case numbers increase? Does activity increase as countries go into lockdown? More ambitious questions that we may or may not be able to answer include: does a spike in COVID cases cause a deterioration in mental health? 

### Data

We source data from two different APIs: for COVID case numbers we use [https://covid19-api.org/](https://covid19-api.org/) which continuously collects case numbers at country level from across the globe; for tweets we user Twitter streaming API. 

### COVID data

COVID data is sourced from the API once every hour. While this introduces many duplicate rows, we make sure that we capture the daily publications of new cases independent of when data is published.  

### Tweets

We stream tweets involving terms in this list `["mental health", "suicide", "depression"]` and dumb the entire JSON objects into our Mongo data base - we thought about filtering out retweets, but decided that the number of times a tweet gets retweeted may be interesting information. At a later stage in the project we will filter this down further. In particular we plan to look for cases among the tweets that also involve `"covid"` or related terms. 
