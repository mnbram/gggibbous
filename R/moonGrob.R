#' Draw a moon
#' 
#' Functions to create and draw crescent or gibbous moon shapes.
#' 
#' Both functions create a moon grob (a graphical object describing a crescent
#' or gibbous moon), but only \code{grid.moon} draws the moon (and then only
#' if draw is TRUE).
#' 
#' These functions calculate a set of points describing the perimeters of the
#' moons and pass these points on to \code{grid::polygonGrob}.
#' 
#' The units in \code{default.units} and \code{size.units} can be different;
#' \code{grid} will add them together appropriately before drawing.
#' 
#' @param ratio A numeric vector with values from 0 to 1 specifying the
#'   proportion of the moons to draw.
#' @param right A boolean vector specifying whether the moon should be filled
#'   from the right (TRUE) or left (FALSE).
#' @param r A numeric vector specifying the radii of the circles describing
#'   the moons.
#' @param angle Not used.
#' @param size.units A string indicating the units to use for the radii of the
#'   moons.
#' @param ... Arguments passed on to \code{grid::polygonGrob}.
#' @inheritParams grid::polygonGrob
#' @return A grob object.
#' @export
#' @examples
#' grid::grid.newpage()
#' grid.moon(x = 1:3 * 0.25, y = rep(0.5, 3), ratio = 1:3 * 0.25, r = 10)
moonGrob <- function(
  x, y, ratio = 0.25, right = TRUE, r = 10, angle = 0,
  default.units = "npc", size.units = "mm", ...
) {
  
  stopifnot(is.numeric(x))
  stopifnot(is.numeric(y))
  stopifnot(is.numeric(ratio))
  if (any(ratio < 0) | any(ratio > 1)) {
    stop("Error: ratios must be between 0 and 1")
  }
  if (!is.logical(right)) {
    stop("Error: `right` must be a logical vector")
  }
  stopifnot(is.logical(right))
  stopifnot(is.numeric(r))
  # stopifnot(is.numeric(angle))
  stopifnot(is.character(default.units))
  stopifnot(is.character(default.units))
  stopifnot(is.character(size.units))
  stopifnot(default.units %in% .grid.unit.list)
  stopifnot(size.units %in% .grid.unit.list)
  stopifnot(length(x) == length(y))
  stopifnot(length(ratio) %in% c(1, length(x)))
  stopifnot(length(right) %in% c(1, length(x)))
  stopifnot(length(r) %in% c(1, length(x)))
  stopifnot(length(angle) %in% c(1, length(x)))
  
  if (length(ratio) == 1) {
    ratio <- rep(ratio, length(x))
  }
  if (length(right) == 1) {
    right <- rep(right, length(x))
  }
  if (length(r) == 1) {
    r <- rep(r, length(x))
  }
  if (length(angle) == 1) {
    angle <- rep(angle, length(x))
  }
  
  coords_list <- mapply(
    moon_coords,
    x = x, y = y, ratio = ratio, right = right, r = r, angle = angle,
    MoreArgs = list(
      default.units = default.units, size.units = size.units
    )
  )
  
  x_coords <- do.call(grid::unit.c, coords_list["x_coords",])
  y_coords <- do.call(grid::unit.c, coords_list["y_coords",])
  
  grid::polygonGrob(
    x_coords, y_coords,
    id.lengths = sapply(coords_list["x_coords",], length),
    default.units = default.units, ...
  )
  
}


#' @rdname moonGrob
#' @export
grid.moon <- function(..., draw = TRUE) {
  mg <- moonGrob(...)
  if (draw) {
    grid::grid.draw(mg)
  }
  invisible(mg)
}


moon_coords <- function(
  x, y, ratio, right, r, angle, default.units, size.units
) {
  if (!grid::is.unit(x)) {
    x <- grid::unit(x, default.units)
  }
  if (!grid::is.unit(y)) {
    y <- grid::unit(y, default.units)
  }
  
  # If the ratio is 0, then we don't want to draw a polygon at all
  if (ratio == 0) {
    return(list(x_coords = x, y_coords = y))
  }
  
  # The circles and ellipses in gggibbous are actually grid's xspline
  # approximation of a cubic B-spline approximation of a Bezier
  # approximation of an ellipse. As such, the "magic" number used here
  # to determine the control points is slightly different than what one would
  # use for a true Bezier curve. This magic number has been determined
  # empirically by eye; it could probably be further refined.
  magic <- 0.571 # Magic number for Bezier approximation of ellipse
  
  # Calculate points of Bezier approximations of circle and ellipse
  # that define the shape.
  # First center the circle and ellipse at the origin (using size.units),
  # then we will translate everything to the right location (using
  # default.units).
  bez_circ_top <- grid::bezierPoints(grid::bezierGrob(
    c(0, magic * r, r, r),
    c(r, r, magic * r, 0),
    default.units = size.units
  ))
  bez_circ_bot <- grid::bezierPoints(grid::bezierGrob(
    c(r, r, magic * r, 0),
    c(0, -magic * r, -r, -r),
    default.units = size.units
  ))
  
  # Calculate scaling factor for ellipse
  e_scale <- -abs(2 * ratio - 1)
  # Crescent or gibbous?
  x_dir <- ifelse(ratio > 0.5, 1, -1)
  
  bez_elli_bot <- grid::bezierPoints(grid::bezierGrob(
    c(0, x_dir * magic * r * e_scale,
      x_dir * r * e_scale, x_dir * r * e_scale),
    c(-r, -r, -magic * r, 0),
    default.units = size.units
  ))
  bez_elli_top <- grid::bezierPoints(grid::bezierGrob(
    c(x_dir * r * e_scale, x_dir * r * e_scale,
      x_dir * magic * r * e_scale, 0),
    c(0, magic * r, r, r),
    default.units = size.units
  ))
  
  # Get x and y coordinates for whole perimeter
  poly_x <- grid::unit.c(
    bez_circ_top$x,
    bez_circ_bot$x[2:length(bez_circ_bot$x)],
    bez_elli_bot$x[2:length(bez_elli_bot$x)],
    bez_elli_top$x[2:(length(bez_elli_top$x) - 1)]
  )
  poly_y <- grid::unit.c(
    bez_circ_top$y,
    bez_circ_bot$y[2:length(bez_circ_bot$y)],
    bez_elli_bot$y[2:length(bez_elli_bot$y)],
    bez_elli_top$y[2:(length(bez_elli_top$y) - 1)]
  )
  
  # For a left-side moon, flip the x values around the origin
  if(right == FALSE) {
    poly_x <- grid::unit(0, size.units) - poly_x
  }
  
  # Translate the shape to the specified center point
  trans_x <- poly_x + x
  trans_y <- poly_y + y
  
  # TODO: Implement rotation
  
  list(x_coords = trans_x, y_coords = trans_y)
}


.grid.unit.list <- c(
  "npc", "cm", "inches", "lines", "native", "null", "snpc", "mm", "points",
  "picas", "bigpts", "dida", "cicero", "scaledpts", "strwidth", "strheight",
  "strascent", "strdescent", "vplayoutwidth", "vplayoutheight", "char", "grobx",
  "groby", "grobwidth", "grobheight", "grobascent", "grobdescent", "mylines",
  "mychar", "mystrwidth", "mystrheight"
)