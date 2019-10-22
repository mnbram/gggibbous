#' gggibbous: Moon charts, a pie chart alternative
#' 
#' Moon charts are like pie charts except that the proportions are
#' shown as crescent or gibbous portions of a circle, like the lit and unlit
#' portions of the moon. As such, they work best with only one or two groups.
#' gggibbous extends ggplot2 to allow for plotting multiple moon charts in a
#' single panel and does not require a square coordinate system.
#' 
#' The workhorse function is \code{geom_moon}, which adds a moon chart layer to
#' a ggplot2 plot.
#' The \code{draw_key_moon} function provides legend key glyphs for plots that
#' use \code{geom_moon}.
#' There are also functions for the raw \code{grid} grobs, \code{grid.moon} and
#' \code{moonGrob}.
#' 
#' @docType package
#' @name gggibbous
NULL