context("test-moonGrob")

test_that("moon grobs are grobs", {
  expect_is(moonGrob(x = 0, y = 0), "grob")
})

test_that("ratio must be between 0 and 1", {
  expect_error(grid.moon(x = 0, y = 0, ratio = 2))
  expect_error(grid.moon(x = 0, y = 0, ratio = -1))
})
