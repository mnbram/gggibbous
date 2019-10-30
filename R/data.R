#' \emph{Adh} allele frequencies in Australasian \emph{Drosophila melanogaster}
#' 
#' This data set contains allele frequencies for the "fast" and "slow" variants
#' of the enzyme alcohol dehydrogenase in Australasian (mostly Australian)
#' populations of \emph{Drosophila melanogaster}. The data are taken from
#' Oakeshott, J.G., et al. 1982. Alcohol dehydrogenase and glycerol-3-phosphate
#' dehydrogenase clines in \emph{Drosophila melanogaster} on different
#' continents. Evolution, 36(1): 86-96.
#' 
#' @format A data frame with 34 rows and 6 variables:
#' \describe{
#'   \item{Locality}{location of population sample}
#'   \item{Latitude}{latitude of population sample}
#'   \item{Longitude}{longitude of population sample}
#'   \item{N}{number of samples}
#'   \item{AdhF}{percent of samples with \emph{Adh^F} allele, as an integer}
#'   \item{AdhS}{percent of samples with \emph{Adh^S} allele, as an integer}
#' }
"dmeladh"

#' Lunar distances and principal phases for 2019
#'
#' This data set contains the distance from the Earth to the Moon for each day
#' in 2019, as well as the dates (in UTC) of each occurrence of the four
#' principal phases of the moon. The data are adapted from NASA.
#' 
#' @format A data frame with 365 rows and 3 variables:
#' \describe{
#'   \item{date}{Date}
#'   \item{distance}{Distance from the Earth to the Moon in kilometers}
#'   \item{phase}{Principal phase of the moon (full, new, first quarter, third
#'   quarter) or NA if no principal phase on that date}
#' }
#' 
#' @source \url{https://svs.gsfc.nasa.gov/4442}
"lunardist"