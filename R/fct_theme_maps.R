theme_maps <- function (gg,showLegend=T, aspectration,...) {
  ggplot2::theme(
    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    axis.text = ggplot2::element_blank()
  )
}
