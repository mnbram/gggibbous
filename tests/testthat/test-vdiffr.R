five_moons <- ggplot2::ggplot(
  data.frame(x = 1:5, y = 1, size = 1:5, ratio = 1:5 * 0.2),
  ggplot2::aes(x = x, y = y, size = size, ratio = ratio)
) +
  geom_moon() +
  ggplot2::scale_size_continuous(range = c(1, 20))

vdiffr::expect_doppelganger("five moons", five_moons)

moon_pseudomap <- ggplot2::ggplot(
  subset(dmeladh, N > 200),
  ggplot2::aes(Longitude, Latitude)
) +
  geom_moon(ggplot2::aes(ratio = AdhF / 100), fill = "black") +
  geom_moon(ggplot2::aes(ratio = AdhS / 100), right = FALSE) +
  ggplot2::coord_fixed()

vdiffr::expect_doppelganger("moon pseudo-map", moon_pseudomap)
