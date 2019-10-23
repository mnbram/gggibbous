library(grid)
library(showtext)
library(svglite)

font_add_google("Economica", "economica")
showtext_auto()

hex_grid <- function(fontsize) {
  grid.newpage()
  hex_r <- 209 / 2
  hex_y <- hex_r * sqrt(3) / 2
  grid.polygon(
    x = unit(c(-hex_y, -hex_y, 0, hex_y, hex_y, 0),
             "bigpts") + unit(0.5, "npc"),
    y = unit(c(hex_r / 2, -hex_r / 2, -hex_r,
               -hex_r / 2, hex_r / 2, hex_r),
             "bigpts") + unit(0.5, "npc"),
    gp = gpar(fill = "black", lwd = 0.5)
  )
  moon_pct <- 0.26
  grid.moon(
    x = 0.5, y = 0.5, ratio = moon_pct, right = FALSE,
    r = 75, default.units = "npc", size.units = "bigpts",
    gp = gpar(fill = "lemonchiffon", color = "black", lwd = 1)
  )
  grid.moon(
    x = 0.5, y = 0.5, ratio = 1 - moon_pct,
    r = 75, default.units = "npc", size.units = "bigpts",
    gp = gpar(fill = "gray15", color = "gray15", lwd = 1)
  )
  grid.text(
    x = unit(0.5, "npc") + unit(-52.5, "bigpts"), y = unit(0.5, "npc"),
    label = "gg", default.units = "npc",
    gp = gpar(fontfamily = "economica", fontsize = fontsize, col = "black")
  )
  grid.text(
    x = unit(0.5, "npc") + unit(17, "bigpts"), y = unit(0.5, "npc"),
    label = "gibbous", default.units = "npc",
    gp = gpar(fontfamily = "economica", fontsize = fontsize, col = "white")
  )
}


png("sticker/gggibbous.png", width = 181, height = 209, bg = NA)
hex_grid(32)
dev.off()

# Font sizes don't make sense
# It seems that a difference in dpi rendering between graphical devices means
# that we need the SVG font size to be 4/3 (96/72) times bigger than for PNG
svglite("sticker/gggibbous.svg", width = 3.62, height = 4.18)
hex_grid(32 * 4 / 3)
dev.off()
