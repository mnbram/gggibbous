five_moons <- ggplot(
  data.frame(x = 1:5, y = 1, size = 1:5, ratio = 1:5 * 0.2),
  aes(x = x, y = y, size = size, ratio = ratio)
) +
  geom_moon() +
  scale_size_continuous(range = c(1, 20))

vdiffr::expect_doppelganger("five moons", five_moons)

moon_pseudomap <- ggplot(
  subset(dmeladh, N > 200),
  aes(Longitude, Latitude)
) +
  geom_moon(aes(ratio = AdhF / 100), fill = "black") +
  geom_moon(aes(ratio = AdhS / 100), right = FALSE) +
  coord_fixed()

vdiffr::expect_doppelganger("moon pseudo-map", moon_pseudomap)
