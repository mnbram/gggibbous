# gggibbous
Moon charts, a pie chart alternative for two groups in ggplot2

![gggibbous](/images/gggibbous.png)

Moon charts are like pie charts except that the proportions are shown as
crescent or gibbous portions of a circle, like the lit and unlit portions of the
moon. As such, they work best with only one or two groups. `gggibbous` extends
`ggplot2` to allow for plotting multiple moon charts in a single panel and does
not require a square coordinate system.

This functionality is particularly useful on maps:

![moon_chart_map](/images/moonmap.png)

`gggibbous` is not yet on CRAN, so the easiest way to install it is with
the `devtools` package:

```r
devtools::install_github("mnbram/gggibbous")
```