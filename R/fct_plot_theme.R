theme_covid_mental <- function () {
  ggplot2::theme_dark() +
    ggplot2::theme(
      panel.background  = ggplot2::element_rect(fill="#333d47", colour=NA),
      plot.background = ggplot2::element_rect(fill="#333d47", colour=NA),
    )
}
