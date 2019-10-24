#' Moon key glyph for legends
#'
#' Draws the legend key glyphs used in \code{geom_moon}.
#' 
#' @inheritParams ggplot2::draw_key
#' @export
draw_key_moon <- function(data, params, size) {
  d_size <- ifelse(is.null(data$size), 10, data$size)
  d_col <- ifelse(is.null(data$colour), "black", data$colour)
  d_fill <- ifelse(is.null(data$fill), "white", data$fill)
  d_stroke <- ifelse(is.null(data$stroke), 0.5, data$stroke)
  d_ltype <- ifelse(is.null(data$linetype), "solid", data$linetype)
  moonGrob(
    0.5, 0.5, r = sqrt(d_size), ratio = 0.75,
    gp = grid::gpar(
      col = scales::alpha(d_col, data$alpha),
      fill = scales::alpha(d_fill, data$alpha),
      lwd = d_stroke * ggplot2::.stroke,
      lty = d_ltype
    )
  )
}


GeomMoon <- ggplot2::ggproto(
  "GeomMoon", ggplot2::Geom,
  
  required_aes = c("x", "y"),
  
  default_aes = ggplot2::aes(
    ratio = 0.25, right = TRUE, size = 10, angle = 0,
    colour = "black", fill = "white", alpha = NA,
    stroke = 0.25, linetype = 1
  ),
  
  draw_key = draw_key_moon,
  
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
#' \code{geom_moon} acts like \code{geom_point} in that mutiple moons can be
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
#' @export
#' @examples
#' # The default size range when mapping size to a variable is often too small
#' # to see the moons clearly
#' ggplot2::ggplot(
#'   data.frame(x = 1:5, y = 1, size = 1:5, ratio = 1:5 * 0.2),
#'   ggplot2::aes(x = x, y = y, size = size, ratio = ratio)
#' ) +
#'   geom_moon() +
#'   ggplot2::scale_size_continuous(range = c(1, 20))
#' 
#' # To make full moon charts, you need to call geom_moon() twice, once with
#' # right = TRUE and once with right = FALSE and ratio equal to 1 - ratio
#' # from the first one  
#' ggplot2::ggplot(dmeladh) +
#'   geom_moon(
#'     x = 0.5, y = 0.5, fill = "forestgreen", color = "forestgreen",
#'     ggplot2::aes(ratio = AdhF / 100)
#'   ) +
#'   geom_moon(
#'     x = 0.5, y = 0.5, fill = "gold", color = "gold",
#'     ggplot2::aes(ratio = AdhS / 100), right = FALSE
#'   ) +
#'   ggplot2::facet_wrap(~Locality, ncol = 7)
#'
#' # Moon charts (and pie charts) are sometimes useful on maps when x and y
#' # cannot be used as aesthetic dimensions because they are already spatial
#' # dimensions. Overplotting needs to be considered carefully, however.   
#' ggplot2::ggplot(
#'   subset(dmeladh, N > 200),
#'   ggplot2::aes(Longitude, Latitude)
#' ) +
#'   geom_moon(ggplot2::aes(ratio = AdhF / 100), fill = "black") +
#'   geom_moon(ggplot2::aes(ratio = AdhS / 100), right = FALSE) +
#'   ggplot2::coord_fixed()
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
