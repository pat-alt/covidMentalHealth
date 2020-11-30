get_sentiment_by <- function(tweets_tidy, ...) {
  tweets_tidy <- tweets_tidy %>%
    dplyr::inner_join(tidytext::get_sentiments("bing")) %>%
    dplyr::count(..., sentiment) %>%
    tidyr::spread(sentiment, n, fill = 0)  %>%
    dplyr::mutate(sentiment = positive - negative)
  suppressWarnings(tweets_tidy[,pos_neg:=ifelse(sentiment>=0, "positive", "negative")])
  return(tweets_tidy)
}
