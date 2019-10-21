GeomMoon <- ggplot2::ggproto(
  "GeomMoon", ggplot2::Geom,
  
  required_aes = c("x", "y"),
  
  default_aes = ggplot2::aes(
    ratio = 0.25, right = TRUE, size = 10, angle = 0,
    colour = "black", fill = "white", alpha = NA,
    stroke = 0.25, linetype = 1
  ),
  
  # TODO: Make a proper legend key
  draw_key = ggplot2::draw_key_point,
  
  draw_panel = function(data, panel_params, coord) {
    coords <- coord$transform(data, panel_params)
    moonGrob(
      coords$x, coords$y, ratio = coords$ratio, right = coords$right,
      r = sqrt(coords$size), # Convert area to radius
      angle = coords$angle,
      gp = grid::gpar(
        col = scales::alpha(coords$colour, coords$alpha),
        fill = scales::alpha(coords$fill, coords$alpha),
        lwd = coords$stroke * ggplot2::.stroke,
        lty = coords$linetype
      )
    )
  }
)


#' Moon charts
#' 
#' The moon geom is used to create moon charts, which are like pie charts except
#' that the proportions are shown as crescent or gibbous portions of a circle,
#' like the lit and unlit portions of the moon. As such, they work best with
#' only one or two groups.
#' 
#' \code{geom_moon} acts like \code{geom_points} in that mutiple moons can be
#' plotted on the same panel with x and y in the plot's coordinate system, but
#' size determined independently of the coordinate system. This behavior also
#' means that the moons will always be circular even if the coordinate system is
#' not square.
#' 
#' In order to get a full circle with two complementary sections (a crescent and
#' a gibbous moon), you need to plot two shapes: one with \code{right = TRUE}
#' and one with \code{right = FALSE}, with \code{ratio} on the second one equal
#' to \code{1 - ratio} on the first.
#' 
#' @inheritParams ggplot2::geom_point
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
#   x = c(1:5), y = 1:5, gibbosity = 0:4 / 4, size = 1:5
# )
# 
# ggplot2::ggplot(df, ggplot2::aes(x, y, size = size)) +
#   geom_moon(ggplot2::aes(ratio = gibbosity), fill = "red", color = "red") +
#   geom_moon(
#     ggplot2::aes(ratio = 1 - gibbosity),
#     fill = "blue", color = "blue", right = FALSE
#   )
