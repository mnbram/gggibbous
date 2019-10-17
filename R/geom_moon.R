library(ggplot2)

GeomMoon <- ggproto(
  "GeomMoon", Geom,
  
  required_aes = c("x", "y"),
  
  default_aes = aes(
    ratio = 0.25, right = TRUE, size = 3, angle = 0,
    colour = "black", fill = "white", alpha = NA,
    stroke = 0.25, linetype = 1
  ),
  
  draw_key = draw_key_point,
  
  draw_panel = function(data, panel_params, coord) {
    coords <- coord$transform(data, panel_params)
    moonGrob(
      coords$x, coords$y, ratio = coords$ratio, right = coords$right,
      size = coords$size, angle = coords$angle,
      gp = gpar(
        col = alpha(coords$colour, coords$alpha),
        fill = alpha(coords$fill, coords$alpha),
        lwd = coords$stroke * .stroke,
        lty = coords$linetype
      )
    )
  }
)


geom_moon <- function(
  mapping = NULL, data = NULL, stat = "identity", position = "identity",
  na.rm = FALSE, show.legend = NA, inherit.aes = TRUE, ...
) {
  layer(
    geom = GeomMoon, mapping = mapping, data = data, stat = stat, 
    position = position, show.legend = show.legend,
    inherit.aes = inherit.aes, params = list(na.rm = na.rm, ...)
  )
}



# Examples ----------------------------------------------------------------

# df <- tibble(
#   x = c(1:5, NA), y = 1:6, gibbosity = 0:5 / 5, size = 2:7
# )
# 
# ggplot(df, aes(x, y, size = size)) +
#   geom_moon(aes(ratio = gibbosity), fill = "red", color = "red") +
#   geom_moon(
#     aes(ratio = 1 - gibbosity),
#     fill = "blue", color = "blue", right = FALSE
#   )

