five_moons <- data.frame(
  x = 1:5,
  y = 1,
  size = 2^(1:5),
  ratio = 0:4 * 0.25,
  group = letters[1:5]
)

moon_size <- ggplot(five_moons, aes(x = x, y = y, size = size)) +
  geom_moon(ratio = 0.5, right = FALSE) +
  scale_size_area(max_size = 10, guide = "none")

vdiffr::expect_doppelganger("moons scale correctly", moon_size)

moon_missing <- ggplot(
  five_moons, aes(x = x, y = y, ratio = ratio, fill = group, color = group)) +
  geom_moon(size = 5) +
  scale_color_discrete(guide = guide_legend(
    keywidth = unit(13, "mm"), keyheight = unit(13, "mm")))

vdiffr::expect_doppelganger("zero ratio moons are invisible", moon_missing)

full_moons <- ggplot(five_moons, aes(x = x, y = y)) +
  geom_moon(aes(ratio = ratio), fill = "black", size = 5) +
  geom_moon(aes(ratio = 1 - ratio), right = FALSE, size = 5)

vdiffr::expect_doppelganger("moons can be complemented", full_moons)
