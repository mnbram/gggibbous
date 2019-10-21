GeomMoon <- ggplot2::ggproto(
  "GeomMoon", ggplot2::Geom,
  
  required_aes = c("x", "y"),
  
  default_aes = ggplot2::aes(
    ratio = 0.25, right = TRUE, size = 3, angle = 0,
    colour = "black", fill = "white", alpha = NA,
    stroke = 0.25, linetype = 1
  ),
  
  # TODO: Make a proper legend key
  draw_key = ggplot2::draw_key_point,
  
  draw_panel = function(data, panel_params, coord) {
    coords <- coord$transform(data, panel_params)
    moonGrob(
      coords$x, coords$y, ratio = coords$ratio, right = coords$right,
      size = coords$size, angle = coords$angle,
      gp = grid::gpar(
        col = scales::alpha(coords$colour, coords$alpha),
        fill = scales::alpha(coords$fill, coords$alpha),
        lwd = coords$stroke * ggplot2::.stroke,
        lty = coords$linetype
      )
    )
  }
)


geom_moon <- function(
  mapping = NULL, data = NULL, stat = "identity", position = "identity",
  na.rm = FALSE, show.legend = NA, inherit.aes = TRUE, ...
) {
  ggplot2::layer(
    geom = GeomMoon, mapping = mapping, data = data, stat = stat, 
    position = position, show.legend = show.legend,
    inherit.aes = inherit.aes, params = list(na.rm = na.rm, ...)
  )
}



# Examples ----------------------------------------------------------------

# df <- data.frame(
#   x = c(1:5, NA), y = 1:6, gibbosity = 0:5 / 5, size = 2:7
# )
# 
# ggplot2::ggplot(df, ggplot2::aes(x, y, size = size)) +
#   geom_moon(ggplot2::aes(ratio = gibbosity), fill = "red", color = "red") +
#   geom_moon(
#     ggplot2::aes(ratio = 1 - gibbosity),
#     fill = "blue", color = "blue", right = FALSE
#   )
