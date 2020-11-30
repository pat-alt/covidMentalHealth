theme_covid_mental <- function () {
  ggplot2::theme_dark() +
    ggplot2::theme(
      legend.background = ggplot2::element_rect(fill="#333d47", colour=NA),
      legend.box.background = ggplot2::element_rect(fill="#333d47", colour=NA),
      panel.background  = ggplot2::element_rect(fill="#333d47", colour=NA),
      plot.background = ggplot2::element_rect(fill="#333d47", colour=NA),
      axis.text = ggplot2::element_text(colour="#acb5bf"),
      axis.title = ggplot2::element_text(colour="#acb5bf"),
      legend.text = ggplot2::element_text(colour="#acb5bf"),
      legend.title= ggplot2::element_text(colour="#acb5bf"),
      panel.grid.major = ggplot2::element_line(colour = "#acb5bf", size = 0.2),
      panel.grid.minor = ggplot2::element_line(colour = "#acb5bf", size = 0.5)
    )
}
