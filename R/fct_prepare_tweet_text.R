prepare_tweet_text <- function(tweets) {

  stop_words <- tidytext::stop_words
  tidy_tweets <- tweets %>%
    tidytext::unnest_tokens(word, text) %>%
    dplyr::anti_join(stop_words)
  return(tidy_tweets)

}
