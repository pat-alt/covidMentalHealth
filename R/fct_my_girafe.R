my_girafe = function(ggobj, width_svg=6, height_svg=5, hover_col="#d211f4",...) {
  ggiraph::girafe(
    ggobj=ggobj,
    width_svg=width_svg,
    height_svg=height_svg,
    options = list(
      ggiraph::opts_hover_inv(css = "opacity:0.1;"),
      ggiraph::opts_hover(css = sprintf("fill:%s;", hover_col)),
      ggiraph::opts_zoom(max = 5)
    ),
    ...
  )
}
