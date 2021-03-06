#' Moon key glyph for legends
#'
#' Draws the legend key glyphs used in \code{geom_moon}.
#'
#' \code{draw_key_moon} (the default in \code{geom_moon}) draws a gibbous moon
#' filled from the right. \code{draw_key_moon_left} draws a crescent moon from
#' the right. \code{draw_key_full_moon} draws a circle, which is very similar to
#' \code{draw_key_point} in \code{ggplot2}, but the size is calculated slightly
#' differently and the default aesthetics differ.
#' 
#' @return A grid grob.
#' 
#' @inheritParams ggplot2::draw_key
#' @export
draw_key_moon <- function(data, params, size) {
  d_size <- ifelse(is.null(data$size), 10, data$size)
  d_col <- ifelse(is.null(data$colour), "black", data$colour)
  d_fill <- ifelse(is.null(data$fill), "white", data$fill)
  d_stroke <- ifelse(is.null(data$stroke), 0.25, data$stroke)
  d_ltype <- ifelse(is.null(data$linetype), "solid", data$linetype)
  moonGrob(
    0.5, 0.5, r = d_size / 2 * 0.75, ratio = 0.75,
    gp = grid::gpar(
      col = scales::alpha(d_col, data$alpha),
      fill = scales::alpha(d_fill, data$alpha),
      lwd = d_stroke * ggplot2::.stroke,
      lty = d_ltype
    )
  )
}

#' @rdname draw_key_moon
#' @export
draw_key_moon_left <- function(data, params, size) {
  d_size <- ifelse(is.null(data$size), 10, data$size)
  d_col <- ifelse(is.null(data$colour), "black", data$colour)
  d_fill <- ifelse(is.null(data$fill), "white", data$fill)
  d_stroke <- ifelse(is.null(data$stroke), 0.25, data$stroke)
  d_ltype <- ifelse(is.null(data$linetype), "solid", data$linetype)
  moonGrob(
    0.5, 0.5, r = d_size / 2 * 0.75, ratio = 0.25,
    gp = grid::gpar(
      col = scales::alpha(d_col, data$alpha),
      fill = scales::alpha(d_fill, data$alpha),
      lwd = d_stroke * ggplot2::.stroke,
      lty = d_ltype
    ),
    right = FALSE
  )
}

#' @rdname draw_key_moon
#' @export
draw_key_full_moon <- function(data, params, size) {
  d_size <- ifelse(is.null(data$size), 10, data$size)
  d_col <- ifelse(is.null(data$colour), "black", data$colour)
  d_fill <- ifelse(is.null(data$fill), "white", data$fill)
  d_stroke <- ifelse(is.null(data$stroke), 0.25, data$stroke)
  d_ltype <- ifelse(is.null(data$linetype), "solid", data$linetype)
  moonGrob(
    0.5, 0.5, r = d_size / 2 * 0.75, ratio = 1,
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
      r = coords$size / 2 * 0.75,
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
#' \code{geom_moon} acts like \code{geom_point} in that multiple moons can be
#' plotted on the same panel with \code{x} and \code{y} in the plot's coordinate
#' system, but size determined independently of the coordinate system. This
#' behavior also means that the moons will always be circular even if the
#' coordinate system is not square.
#' 
#' In order to get a full circle with two complementary sections (a crescent and
#' a gibbous moon), you need to plot two shapes: one with \code{right = TRUE}
#' and one with \code{right = FALSE}, with \code{ratio} on the second one equal
#' to \code{1 - ratio} on the first.
#' 
#' @section Aesthetics:
#' \code{x} and \code{y} are required aesthetics.
#' \code{size}, \code{fill},
#' \code{colo(u)r}, \code{alpha}, \code{stroke}, and \code{group} aesthetics
#' are understood as in other \code{geom}s.
#' Two new aesthetics are also introduced: \code{ratio} and \code{right}.
#' \code{ratio} controls the proportion of the moon to be plotted, from 0 to 1.
#' \code{right} takes a boolean value to indicate whether the moon should be
#' filled from the right or the left.
#' 
#' @inheritParams ggplot2::geom_point
#' @export
#' @import ggplot2
#' @examples
#' ggplot(
#'   data.frame(x = 1:5, y = 1, size = 1:5, ratio = 1:5 * 0.2),
#'   aes(x = x, y = y, size = size, ratio = ratio)
#' ) +
#'   geom_moon()
#' 
#' # To make full moon charts, you need two calls to geom_moon(), one with
#' # right = TRUE and one with right = FALSE and ratio equal to 1 - ratio
#' # from the first one 
#' ggplot(dmeladh) +
#'   geom_moon(
#'     x = 0.5, y = 0.5, fill = "forestgreen", color = "forestgreen",
#'     aes(ratio = AdhF / 100)
#'   ) +
#'   geom_moon(
#'     x = 0.5, y = 0.5, fill = "gold", color = "gold",
#'     aes(ratio = AdhS / 100), right = FALSE
#'   ) +
#'   facet_wrap(~Locality, ncol = 7)
#'
#' # The same thing can be accomplished with a single call to geom_moon()
#' # using a "long" data frame with both frequencies if you set a grouping
#' # variable and set the `right` variable to a boolean column
#' dmeladh_long <- reshape(
#'   dmeladh,
#'   varying = c("AdhF", "AdhS"),
#'   v.names = "freq",
#'   timevar = "allele",
#'   times = c("AdhF", "AdhS"),
#'   idvar = c("Locality", "Latitude", "Longitude", "N"),
#'   direction = "long"
#' )
#' dmeladh_long$right <- rep(c(TRUE, FALSE), each = nrow(dmeladh))
#' ggplot(dmeladh_long) +
#'   geom_moon(
#'     x = 0.5, y = 0.5, key_glyph = draw_key_rect,
#'     aes(ratio = freq / 100, fill = allele, color = allele, right = right),
#'   ) +
#'   facet_wrap(~Locality, ncol = 7)
#'
#' # Moon charts (and pie charts) are sometimes useful on maps when x and y
#' # cannot be used as aesthetic dimensions because they are already spatial
#' # dimensions. Overplotting needs to be considered carefully, however.   
#' ggplot(
#'   subset(dmeladh, N > 200),
#'   aes(Longitude, Latitude)
#' ) +
#'   geom_moon(aes(ratio = AdhF / 100), fill = "black") +
#'   geom_moon(aes(ratio = AdhS / 100), right = FALSE) +
#'   coord_fixed()
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
