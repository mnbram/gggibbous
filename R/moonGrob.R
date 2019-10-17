library(grid)

moonGrob <- function(
  x, y, ratio = 0.25, right = TRUE, size = 1, angle = 0,
  default.units = "npc", size.units = "mm", ...
) {
  
  stopifnot(is.numeric(x))
  stopifnot(is.numeric(y))
  stopifnot(is.numeric(ratio))
  stopifnot(all(ratio >= 0), all(ratio <= 1))
  stopifnot(is.logical(right))
  stopifnot(is.numeric(size))
  stopifnot(is.numeric(angle))
  stopifnot(is.character(default.units))
  stopifnot(is.character(default.units))
  stopifnot(is.character(size.units))
  stopifnot(default.units %in% grid:::.grid.unit.list)
  stopifnot(size.units %in% grid:::.grid.unit.list)
  stopifnot(length(x) == length(y))
  stopifnot(length(ratio) %in% c(1, length(x)))
  stopifnot(length(right) %in% c(1, length(x)))
  stopifnot(length(size) %in% c(1, length(x)))
  stopifnot(length(angle) %in% c(1, length(x)))
  
  if (length(ratio) == 1) {
    ratio <- rep(ratio, length(x))
  }
  if (length(right) == 1) {
    right <- rep(right, length(x))
  }
  if (length(size) == 1) {
    size <- rep(size, length(x))
  }
  if (length(angle) == 1) {
    angle <- rep(angle, length(x))
  }
  
  coords_list <- mapply(
    moon_coords,
    x = x, y = y, ratio = ratio, right = right, size = size, angle = angle,
    MoreArgs = list(
      default.units = default.units, size.units = size.units
    )
  )
  
  x_coords <- do.call(unit.c, coords_list["x_coords",])
  y_coords <- do.call(unit.c, coords_list["y_coords",])
  
  polygonGrob(
    x_coords, y_coords,
    id.lengths = sapply(coords_list["x_coords",], length),
    default.units = default.units, ...
  )
  
}


grid.moon <- function(..., draw = TRUE) {
  mg <- moonGrob(...)
  if (draw) {
    grid.draw(mg)
  }
  invisible(mg)
}


moon_coords <- function(
  x, y, ratio, right, size, angle, default.units, size.units
) {
  magic <- 0.571 # Magic number for Bezier approximation of ellipse
  
  # Calculate points of Bezier approximations of circle and ellipse
  # that define the shape.
  # First center the circle and ellipse at the origin (using size.units),
  # then we will translate everything to the right location (using
  # default.units).
  bez_circ_top <- bezierPoints(bezierGrob(
    c(0, magic * size, size, size),
    c(size, size, magic * size, 0),
    default.units = size.units
  ))
  bez_circ_bot <- bezierPoints(bezierGrob(
    c(size, size, magic * size, 0),
    c(0, -magic * size, -size, -size),
    default.units = size.units
  ))
  
  # Calculate scaling factor for ellipse
  e_scale <- -abs(2 * ratio - 1)
  # Crescent or gibbous?
  x_dir <- ifelse(ratio > 0.5, 1, -1)
  
  bez_elli_bot <- bezierPoints(bezierGrob(
    c(0, x_dir * magic * size * e_scale,
      x_dir * size * e_scale, x_dir * size * e_scale),
    c(-size, -size, -magic * size, 0),
    default.units = size.units
  ))
  bez_elli_top <- bezierPoints(bezierGrob(
    c(x_dir * size * e_scale, x_dir * size * e_scale,
      x_dir * magic * size * e_scale, 0),
    c(0, magic * size, size, size),
    default.units = size.units
  ))
  
  # Get x and y coordinates for whole perimeter
  poly_x <- unit.c(
    bez_circ_top$x,
    bez_circ_bot$x[2:length(bez_circ_bot$x)],
    bez_elli_bot$x[2:length(bez_elli_bot$x)],
    bez_elli_top$x[2:(length(bez_elli_top$x) - 1)]
  )
  poly_y <- unit.c(
    bez_circ_top$y,
    bez_circ_bot$y[2:length(bez_circ_bot$y)],
    bez_elli_bot$y[2:length(bez_elli_bot$y)],
    bez_elli_top$y[2:(length(bez_elli_top$y) - 1)]
  )
  
  # For a left-side moon, flip the x values around the origin
  if(right == FALSE) {
    poly_x <- unit(0, size.units) - poly_x
  }
  
  # Translate the shape to the specified center point
  if (!is.unit(x)) {
    x <- unit(x, default.units)
  }
  if (!is.unit(y)) {
    y <- unit(y, default.units)
  }
  trans_x <- poly_x + x
  trans_y <- poly_y + y
  
  # TODO: Implement rotation
  # FIXME: If ratio is 0 or 1, return a dummy point
  
  list(x_coords = trans_x, y_coords = trans_y)
}


# Examples ----------------------------------------------------------------

# grid.newpage()
# grid.moon(
#   20, 20, ratio = 0.25, size = 10, default.units = "mm",
#   gp = gpar(fill = "firebrick2", col = "firebrick2")
# )
# grid.moon(
#   20, 20, ratio = 0.75, size = 10, default.units = "mm", right = FALSE,
#   gp = gpar(fill = "dodgerblue2", col = "dodgerblue2")
# )
# grid.moon(
#   50, 50, ratio = 0.5, size = 10, default.units = "mm",
#   gp = gpar(fill = "forestgreen")
# )
# grid.moon(
#   50, 50, ratio = 0.5, size = 10, default.units = "mm", right = FALSE,
#   gp = gpar(fill = "gold1")
# )
# grid.moon(
#   80, 80, ratio = 0.9, size = 15, default.units = "mm"
# )
# grid.moon(
#   80, 80, ratio = 0.1, size = 15, default.units = "mm", right = FALSE
# )
# grid.moon(
#   110, 50, ratio = 0.6, size = 15, default.units = "mm",
#   gp = gpar(fill = "chartreuse3", lwd = 0)
# )
# grid.moon(
#   110, 50, ratio = 0.4, size = 15, default.units = "mm", right = FALSE,
#   gp = gpar(fill = "blueviolet", lwd = 0)
# )
# grid.circle(
#   80, 20, 10, default.units = "mm",
#   gp = gpar(fill = "yellow", alpha = 0.5, lwd = 0)
# )
# grid.moon(
#   80, 20, ratio = 1, size = 10, default.units = "mm",
#   gp = gpar(fill = "cyan", alpha = 0.5, lwd = 0)
# )
# grid.moon(
#   0.8, 0.5, ratio = 0.25, size = 10, default.units = "npc"
# )

# grid.newpage()
# grid.moon(
#   x = rep(1:10/11, 10), y = rep(10:1/11, each = 10), ratio = 1:100/100,
#   size = 3, gp = gpar(
#     col = hcl(0:99*3.6, c = 60, l = 70),
#     fill = hcl(0:99*3.6, c = 60, l = 70)
#   )
# )
