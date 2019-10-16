library(grid)

# Bezier to polygon -------------------------------------------------------

grid.moon <- function(
  x, y, ratio = 0.25, right = TRUE, size = 1, angle = 0,
  default.units = "npc", ...
) {
  
  # FIXME: Add checks for valid input values
  
  magic <- 0.571 # Magic number for Bezier approximation of ellipse
  
  # Calculate points of Bezier approximations of circle and ellipse
  # that define the shape
  bez_circ_top <- bezierPoints(bezierGrob(
    c(x, x + magic * size, x + size, x + size),
    c(y + size, y + size, y + magic * size, y),
    default.units = default.units
  ))
  bez_circ_bot <- bezierPoints(bezierGrob(
    c(x + size, x + size, x + magic * size, x),
    c(y, y - magic * size, y - size, y - size),
    default.units = default.units
  ))
  
  # Calculate scaling factor for ellipse
  e_scale <- -abs(2 * ratio - 1)
  # Crescent or gibbous?
  x_dir <- ifelse(ratio > 0.5, 1, -1)
  
  bez_elli_bot <- bezierPoints(bezierGrob(
    c(x, x + x_dir * magic * size * e_scale,
      x + x_dir * size * e_scale, x + x_dir * size * e_scale),
    c(y - size, y - size, y - magic * size, y),
    default.units = default.units
  ))
  bez_elli_top <- bezierPoints(bezierGrob(
    c(x + x_dir * size * e_scale, x + x_dir * size * e_scale,
      x + x_dir * magic * size * e_scale, x),
    c(y, y + magic * size, y + size, y + size),
    default.units = default.units
  ))
  
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
    poly_x <- unit(x, default.units) - (poly_x - unit(x, default.units))
  }
  
  # FIXME: Implement rotation
  
  grid.polygon(poly_x, poly_y, default.units = default.units, ...)
}



# Examples ----------------------------------------------------------------

grid.newpage()
grid.moon(
  20, 20, ratio = 0.25, size = 10, default.units = "mm",
  gp = gpar(fill = "firebrick2", col = "firebrick2")
)
grid.moon(
  20, 20, ratio = 0.75, size = 10, default.units = "mm", right = FALSE,
  gp = gpar(fill = "dodgerblue2", col = "dodgerblue2")
)
grid.moon(
  50, 50, ratio = 0.5, size = 10, default.units = "mm",
  gp = gpar(fill = "forestgreen")
)
grid.moon(
  50, 50, ratio = 0.5, size = 10, default.units = "mm", right = FALSE,
  gp = gpar(fill = "gold1")
)
grid.moon(
  80, 80, ratio = 0.9, size = 15, default.units = "mm"
)
grid.moon(
  80, 80, ratio = 0.1, size = 15, default.units = "mm", right = FALSE
)
grid.moon(
  110, 50, ratio = 0.6, size = 15, default.units = "mm",
  gp = gpar(fill = "chartreuse3", lwd = 0)
)
grid.moon(
  110, 50, ratio = 0.4, size = 15, default.units = "mm", right = FALSE,
  gp = gpar(fill = "blueviolet", lwd = 0)
)
grid.circle(
  80, 20, 10, default.units = "mm",
  gp = gpar(fill = "yellow", alpha = 0.5, lwd = 0)
)
grid.moon(
  80, 20, ratio = 1, size = 10, default.units = "mm",
  gp = gpar(fill = "cyan", alpha = 0.5, lwd = 0)
)
